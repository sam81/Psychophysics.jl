#   Copyright (C) 2013-2020 Samuele Carcagno <sam.carcagno@gmail.com>
#   This file is part of Psychophysics.jl

#    Psychophysics.jl is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.

#    Psychophysics.jl is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with Psychophysics.jl.  If not, see <http://www.gnu.org/licenses/>.

mutable struct AdaptiveStaircase{S<:Real, T<:Real, V<:Real, P<:Int}
    paradigm::String
    nCorrectNeeded::Int
    nIncorrectNeeded::Int
    stepSizes::AbstractVector{T}
    turnpointsXStepSizes::AbstractVector{P}
    procedure::String
    adaptiveParam::Real
    responses::AbstractVector{P}
    levels::AbstractVector{S}
    corrTrackDir::String
    incorrTrackDir::String
    trackDir::String
    corrTrackSign::Int
    incorrTrackSign::Int
    turnpoints::AbstractVector{V}
    correctCount::Int
    incorrectCount::Int
    percCorrTracked::Union{Missing,Real}
    terminationRule::String
    nTrialsToRun::Real
    nTurnpointsToRun::Real
    nTrials::Real
    nTurnpoints::Real
    finished::Bool
    turnpointAverage::Real
    turnpointSD::Real
end

"""
Initialize an adaptive staircase track.

$(SIGNATURES)

##### Parameters

* `paradigm`: ``transformed up-down``, or ``weighted up-down``

##### Returns

* `AdaptiveStaircase`: An AdaptiveStaircase object.

##### Examples

```julia
TUD = initTUD(paradigm="transformed up-down",
              nCorrectNeeded=2,
              nIncorrectNeeded=1,
              stepSizes=[4,2],
              turnpointsXStepSizes=[4,12],
              procedure="arithmetic",
              corrTrackDir="down",
              terminationRule="turnpoints",
              nTurnpointsToRun=16)
```
"""
function initTUD(;paradigm::String="transformed up-down",
                 nCorrectNeeded::Int=2, nIncorrectNeeded::Int=1,
                 stepSizes::AbstractVector{T}=[4,2],
                 turnpointsXStepSizes::AbstractVector{P}=[4,12],
                 procedure::String="arithmetic",
                 corrTrackDir::String="down", percCorrTracked::Real=75,
                 terminationRule::String="turnpoints",
    nTrialsToRun::Real=100,
    nTurnpointsToRun::Real=sum(turnpointsXStepSizes)) where {T<:Real, P<:Int}
    
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
        percCorrTracked = missing #0.5^(1/nCorrectNeeded)
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
                            percCorrTracked,
                            terminationRule,
                            nTrialsToRun,
                            nTurnpointsToRun,
                            0,
                            0,
                            false,
                            NaN,
                            NaN)
    return TUD
end

              
function update!(TUD::AdaptiveStaircase, level::Real, resp::Int)
    push!(TUD.responses, resp)
    push!(TUD.levels, level)
    TUD.nTrials = TUD.nTrials+1
    TUD.adaptiveParam = level
    nTurnpoints = length(TUD.turnpoints)
    changeStepPoints = cumsum(TUD.turnpointsXStepSizes)
    #determine current step index
    stepIndexFound = false
    for i=1:length(changeStepPoints)
        if  nTurnpoints < changeStepPoints[i]
            stepIndex = i
            stepIndexFound = true
            break
        end
    end
    if stepIndexFound == false #there may be more turnpoints than the planned number (e.g. in interleaved tracks)
        stepIndex = length(changeStepPoints) #use the last step size
    end

    stepSize = Dict{String, Real}()
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
        TUD.incorrectCount = 0
        if TUD.correctCount == TUD.nCorrectNeeded
            TUD.correctCount = 0
            if TUD.trackDir == TUD.incorrTrackDir
                push!(TUD.turnpoints, TUD.adaptiveParam)
                TUD.trackDir = TUD.corrTrackDir #copy(TUD.corrTrackDir)
                TUD.nTurnpoints = TUD.nTurnpoints + 1
            end           
            if TUD.procedure == "arithmetic"
                TUD.adaptiveParam = TUD.adaptiveParam + (stepSize[TUD.corrTrackDir]*TUD.corrTrackSign)
            elseif TUD.procedure == "geometric"
                TUD.adaptiveParam = TUD.adaptiveParam * (float(stepSize[TUD.corrTrackDir])^TUD.corrTrackSign)
            end
        end
    elseif resp == 0
        TUD.incorrectCount = TUD.incorrectCount+1
        TUD.correctCount = 0
        if TUD.incorrectCount == TUD.nIncorrectNeeded
            TUD.incorrectCount = 0
            if TUD.trackDir == TUD.corrTrackDir
                push!(TUD.turnpoints, TUD.adaptiveParam)
                TUD.trackDir = TUD.incorrTrackDir #copy(TUD.incorrTrackDir)
                TUD.nTurnpoints = TUD.nTurnpoints + 1
            end           
            if TUD.procedure == "arithmetic"
                TUD.adaptiveParam = TUD.adaptiveParam + (stepSize[TUD.incorrTrackDir]*TUD.incorrTrackSign)
            elseif TUD.procedure == "geometric"
                TUD.adaptiveParam = TUD.adaptiveParam * (float(stepSize[TUD.incorrTrackDir])^TUD.incorrTrackSign)
            end
        end
    end

    if ((TUD.terminationRule == "turnpoints") & (TUD.nTurnpoints == TUD.nTurnpointsToRun))
        TUD.finished = true
    end

    if ((TUD.terminationRule == "trials") & (TUD.nTrials == TUD.nTrialsToRun))
        TUD.finished = true
    end

    if TUD.finished == true
        if TUD.turnpointsXStepSizes == 1
            idxStart = 1
        else
            idxStart = TUD.turnpointsXStepSizes[length(TUD.turnpointsXStepSizes)-1]+1
        end
        if TUD.procedure == "arithmetic"
            TUD.turnpointAverage = mean(TUD.turnpoints[idxStart:end])
            TUD.turnpointSD = std(TUD.turnpoints[idxStart:end])
        elseif TUD.procedure == "geometric"
            TUD.turnpointAverage = geoMean(TUD.turnpoints[idxStart:end])
            TUD.turnpointSD = geoSD(TUD.turnpoints[idxStart:end])
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
