using Test, Psychophysics

@test_throws(ErrorException, geoMean([-1,2,3]))
@test_throws(ErrorException, wGeoMean([-1,2,3], [0.4, 0.2, 0.4]))
@test_throws(ErrorException, geoSD([-1,2,3]))
@test_throws(ErrorException, geoSE([-1,2,3]))

@test_throws(ErrorException, betaABFromMeanSTD(-0.1, 0.2))
@test_throws(ErrorException, betaABFromMeanSTD(1.1, 0.2))
@test_throws(ErrorException, betaABFromMeanSTD(0.01, 0.1))

## @test_throws(ErrorException, gammaShRaFromMeanSD(-0.1, 0.1))
## @test_throws(ErrorException, gammaShRaFromMeanSD(0.1, -0.1))

## @test_throws(ErrorException, gammaShRaFromModeSD(-0.1, 0.1))
## @test_throws(ErrorException, gammaShRaFromModeSD(0.1, -0.1))

