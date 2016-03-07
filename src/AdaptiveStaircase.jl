type AdaptiveStaircase{S<:Real, T<:Real, V<:Real, P<:Int}
    paradigm::ASCIIString
    nCorrectNeeded::Int
    nIncorrectNeeded::Int
    stepSizes::AbstractVector{T}
    turnpointsXStepSizes::AbstractVector{P}
    procedure::ASCIIString
    adaptiveParam::Real
    responses::AbstractVector{P}
    levels::AbstractVector{S}
    corrTrackDir::ASCIIString
    incorrTrackDir::ASCIIString
    trackDir::ASCIIString
    corrTrackSign::Int
    incorrTrackSign::Int
    turnpoints::AbstractVector{V}
    correctCount::Int
    incorrectCount::Int
    percCorrTracked::Real
end

function initTUD{T<:Real, P<:Int}(;paradigm::ASCIIString="transformed up-down",
                                  nCorrectNeeded::Int=2, nIncorrectNeeded::Int=1,
                                  stepSizes::AbstractVector{T}=[4,2],
                                  turnpointsXStepSizes::AbstractVector{P}=[4,12],
                                  procedure::ASCIIString="arithmetic",
                                  corrTrackDir::ASCIIString="down", percCorrTracked::Real=75)

    if corrTrackDir == "down"
        incorrTrackDir = "up"
        corrTrackSign = -1
        incorrTrackSign = 1
        trackDir = "down"
    else
        incorrTrackDir = "down"
        corrTrackSign = 1
        incorrTrackSign = -1
        trackDir = "up"
    end

    if paradigm == "transformed up-down"
        percCorrTracked = 0.5^(1/nCorrectNeeded)
    end
    adaptiveParam = 0
    TUD = AdaptiveStaircase(paradigm,
                 nCorrectNeeded,
                 nIncorrectNeeded,
                 stepSizes,
                 turnpointsXStepSizes,
                 procedure,
                 adaptiveParam,
                 (Int)[],
                 (Float64)[],
                 corrTrackDir,
                 incorrTrackDir,
                 trackDir,
                 corrTrackSign,
                 incorrTrackSign,
                 (Float64)[],
                 0,
                 0,
                 percCorrTracked)
    return TUD
end

              
function update!(TUD::AdaptiveStaircase, level::Real, resp::Int)
    push!(TUD.responses, resp)
    push!(TUD.levels, level)
    TUD.adaptiveParam = level
    nTurnpoints = length(TUD.turnpoints)
    changeStepPoints = cumsum(TUD.turnpointsXStepSizes)
    #determine current step index
    stepIndexFound = false
    for i=1:length(changeStepPoints)
        if  nTurnpoints <= changeStepPoints[i]
            stepIndex = i
            stepIndexFound = true
            break
        end
    end
    if stepIndexFound == false #there may be more turnpoints than the planned number (e.g. in interleaved tracks)
        stepIndex = length(changeStepPoints) #use the last step size
    end

    stepSize = Dict{ASCIIString, Real}()
    if TUD.paradigm == "transformed up-down"
        stepSize["down"] = TUD.stepSizes[stepIndex]
        stepSize["up"] = TUD.stepSizes[stepIndex]
    elseif TUD.paradigm == "weighted up-down"
        stepSize[TUD.corrTrackDir] = TUD.stepSizes[stepIndex]
        if TUD.procedure == "arithmetic"
            stepSize[TUD.incorrTrackDir] =  TUD.stepSizes[stepIndex] * (TUD.percCorrTracked / (100-TUD.percCorrTracked))
        elseif TUD.procedure == "geometric"
            stepSize[TUD.incorrTrackDir] = TUD.stepSizes[stepIndex]^(TUD.percCorrTracked / (100-TUD.percCorrTracked))
        end
    end

    if resp == 1
        TUD.correctCount = TUD.correctCount+1
        if TUD.correctCount == TUD.nCorrectNeeded
            TUD.correctCount = 0
            if TUD.trackDir == TUD.incorrTrackDir
                push!(TUD.turnpoints, TUD.adaptiveParam)
                TUD.trackDir = copy(TUD.corrTrackDir)
            end           
            if TUD.procedure == "arithmetic"
                TUD.adaptiveParam = TUD.adaptiveParam + (stepSize[TUD.corrTrackDir]*TUD.corrTrackSign)
            elseif TUD.procedure == "geometric"
                TUD.adaptiveParam = TUD.adaptiveParam * (stepSize[TUD.corrTrackDir]^TUD.corrTrackSign)
            end
        end
    elseif resp == 0
        TUD.incorrectCount = TUD.incorrectCount+1
        if TUD.incorrectCount == TUD.nIncorrectNeeded
            TUD.incorrectCount = 0
            if TUD.trackDir == TUD.corrTrackDir
                push!(TUD.turnpoints, TUD.adaptiveParam)
                TUD.trackDir = copy(TUD.incorrTrackDir)
            end           
            if TUD.procedure == "arithmetic"
                TUD.adaptiveParam = TUD.adaptiveParam + (stepSize[TUD.corrTrackDir]*TUD.incorrTrackSign)
            elseif TUD.procedure == "geometric"
                TUD.adaptiveParam = TUD.adaptiveParam * (stepSize[TUD.corrTrackDir]^TUD.incorrTrackSign)
            end
        end
    end
    
    
end

# TUD = initTUD(paradigm="transformed up-down", nCorrectNeeded=2, nIncorrectNeeded=1, stepSizes=[5,2.5], turnpointsXStepSizes=[4,12],
#             procedure="arithmetic", corrTrackDir="down")

# update!(TUD, 20, 1)
# finished = false
# while finished == false
#     update!(TUD, TUD.adaptiveParam, round(Int, rand(1)[1]))
#     if length(TUD.turnpoints) == 16
#         finished = true
#     end
# end
