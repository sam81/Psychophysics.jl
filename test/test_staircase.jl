using DataFrames, Psychophysics
using Base.Test

test_data_dir = "../../Psychophysics_test_data/"

pyResTrialFile = test_data_dir * "pychoacoustics_data/transformed_up-down/res_arithmetic_table_trial.csv"
pyResBlockFile = test_data_dir * "pychoacoustics_data/transformed_up-down/res_arithmetic_table.csv"
pyResBlockData = readtable(pyResBlockFile, separator=';')

for bln=1:2
    TUD = initTUD(paradigm="transformed up-down",
                  nCorrectNeeded=2,
                  nIncorrectNeeded=1,
                  stepSizes=[4,2],
                  turnpointsXStepSizes=[4,12],
                  procedure="arithmetic",
                  corrTrackDir="down",
                  terminationRule="turnpoints",
                  nTurnpointsToRun=16)
    pyResTrialData = readtable(pyResTrialFile, separator=';')
    pyResTrialData = pyResTrialData[pyResTrialData[:block] .== bln,:]

    update!(TUD, pyResTrialData[:adaptive_difference][1], pyResTrialData[:response][1])
    for i=2:length(pyResTrialData[:response])
        update!(TUD, TUD.adaptiveParam, pyResTrialData[:response][i])
    end

    @test isapprox(round(TUD.turnpointAverage,3), round(pyResBlockData[:threshold_arithmetic][bln],3))
    @test isapprox(round(TUD.turnpointSD, 3), round(pyResBlockData[:SD][bln], 3))
                   

end


pyResTrialFile = test_data_dir * "pychoacoustics_data/transformed_up-down/res_geometric_table_trial.csv"
pyResBlockFile = test_data_dir * "pychoacoustics_data/transformed_up-down/res_geometric_table.csv"
pyResBlockData = readtable(pyResBlockFile, separator=';')

for bln=1:2
    TUD = initTUD(paradigm="transformed up-down",
                  nCorrectNeeded=2,
                  nIncorrectNeeded=1,
                  stepSizes=[2,1.414],
                  turnpointsXStepSizes=[4,12],
                  procedure="geometric",
                  corrTrackDir="down",
                  terminationRule="turnpoints",
                  nTurnpointsToRun=16)
    pyResTrialData = readtable(pyResTrialFile, separator=';')
    pyResTrialData = pyResTrialData[pyResTrialData[:block] .== bln,:]

    update!(TUD, pyResTrialData[:adaptive_difference][1], pyResTrialData[:response][1])
    for i=2:length(pyResTrialData[:response])
        update!(TUD, TUD.adaptiveParam, pyResTrialData[:response][i])
    end

    @test isapprox(round(TUD.turnpointAverage,3), round(pyResBlockData[:threshold_geometric][bln],3))
    @test isapprox(round(TUD.turnpointSD, 3), round(pyResBlockData[:SD][bln], 3))
                   

end


pyResTrialFile = test_data_dir * "pychoacoustics_data/weighted_up-down/res_arithmetic_table_trial.csv"
pyResBlockFile = test_data_dir * "pychoacoustics_data/weighted_up-down/res_arithmetic_table.csv"
pyResBlockData = readtable(pyResBlockFile, separator=';')

for bln=1:2
    TUD = initTUD(paradigm="weighted up-down",
                  nCorrectNeeded=1,
                  nIncorrectNeeded=1,
                  stepSizes=[4,2],
                  turnpointsXStepSizes=[4,12],
                  procedure="arithmetic",
                  corrTrackDir="down",
                  percCorrTracked=75,
                  terminationRule="turnpoints",
                  nTurnpointsToRun=16)
    pyResTrialData = readtable(pyResTrialFile, separator=';')
    pyResTrialData = pyResTrialData[pyResTrialData[:block] .== bln,:]

    update!(TUD, pyResTrialData[:adaptive_difference][1], pyResTrialData[:response][1])
    for i=2:length(pyResTrialData[:response])
        update!(TUD, TUD.adaptiveParam, pyResTrialData[:response][i])
    end

    @test isapprox(round(TUD.turnpointAverage,3), round(pyResBlockData[:threshold_arithmetic][bln],3))
    @test isapprox(round(TUD.turnpointSD, 3), round(pyResBlockData[:SD][bln], 3))
                   
end


pyResTrialFile = test_data_dir * "pychoacoustics_data/weighted_up-down/res_geometric_table_trial.csv"
pyResBlockFile = test_data_dir * "pychoacoustics_data/weighted_up-down/res_geometric_table.csv"
pyResBlockData = readtable(pyResBlockFile, separator=';')

for bln=1:2
    TUD = initTUD(paradigm="weighted up-down",
                  nCorrectNeeded=1,
                  nIncorrectNeeded=1,
                  stepSizes=[2,1.414],
                  turnpointsXStepSizes=[4,12],
                  procedure="geometric",
                  corrTrackDir="down",
                  percCorrTracked=75,
                  terminationRule="turnpoints",
                  nTurnpointsToRun=16)
    pyResTrialData = readtable(pyResTrialFile, separator=';')
    pyResTrialData = pyResTrialData[pyResTrialData[:block] .== bln,:]

    update!(TUD, pyResTrialData[:adaptive_difference][1], pyResTrialData[:response][1])
    for i=2:length(pyResTrialData[:response])
        update!(TUD, TUD.adaptiveParam, pyResTrialData[:response][i])
    end

    @test isapprox(round(TUD.turnpointAverage,3), round(pyResBlockData[:threshold_geometric][bln],3))
    @test isapprox(round(TUD.turnpointSD, 3), round(pyResBlockData[:SD][bln], 3))
                   
end
