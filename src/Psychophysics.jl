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

module Psychophysics

export deltaLToWeberFracdB, gaussianPsy, geoMean, geoSD, geoSE, gumbelPsy, invGaussianPsy, invGumbelPsy, invLogisticPsy, invWeibullPsy, logisticPsy, SE, weberFracdBToDeltaL, weibullPsy, wGeoMean

export initTUD, update!
export setupUML, UML_update
export betaABFromMeanSTD, generalizedBetaABFromMeanSTD


using DocStringExtensions, SpecialFunctions, Statistics
include("AdaptiveStaircase.jl")
#include("UML.jl")
include("stats_utils.jl")
include("utils.jl")

"""
Compute the gaussian psychometric function.

$(SIGNATURES)

##### Parameters

* `x`: Stimulus level(s).
* `midpoint`: Mid-point(s) of the psychometric function.
* `slope`: The slope of the psychometric function.
* `guess`: Lower limit of the psychometric function. Guess rate.
* `lapse`: Lapse rate.

##### Returns

* `pc`: The proportion correct at the stimulus level `x` for the psychometric function defined
    by the input parameters.
    
##### Examples

```julia
gaussianPsy(2.5, 3, 2, 0.5, 0.001)
# for several x
gaussianPsy([2.5, 3, 3.5], 3, 2, 0.5, 0.001)
# for several midpoints
gaussianPsy(2.5, [3, 3.5, 4], 2, 0.5, 0.001)
```
"""
function gaussianPsy(x::Real, midpoint::Real, slope::Real, guess::Real, lapse::Real)
    # as in UML toolbox
    out = guess+(1-guess-lapse)*(1+erf((x-midpoint)/sqrt(2*slope^2)))/2
    return out
end

function gaussianPsy(x::AbstractVector{T}, midpoint::Real, slope::Real, guess::Real, lapse::Real) where {T<:Real}
    # as in UML toolbox
    out = guess .+ (1-guess-lapse)*(1 .+ erf.((x .- midpoint)/sqrt(2*slope^2)))/2
    return out
end

function gaussianPsy(x::Real, midpoint::AbstractVector{T}, slope::Real, guess::Real, lapse::Real) where {T<:Real}
    # as in UML toolbox
    out = guess .+ (1-guess-lapse)*(1 .+ erf.((x .- midpoint)/sqrt(2*slope^2)))/2
    return out
end

"""
Compute the inverse of the gaussian psychometric function.

$(SIGNATURES)

##### Parameters

* `p`: Proportion correct on the psychometric function.
* `midpoint`: Mid-point(s) of the psychometric function.
* `slope`: The slope of the psychometric function.
* `guess`: Lower limit of the psychometric function.
* `lapse`: The lapse rate.

##### Returns

* `x`: the stimulus level at which the proportion correct equals `p` for the
  psychometric function defined by the input parameters.

##### Examples

```julia
invGaussianPsy(0.9, 5, 1, 0.5, 0.02)
# for several pc
invGaussianPsy([0.7, 0.8, 0.9], 5, 1, 0.5, 0.02)
#for several midpoints
invGaussianPsy(0.9, [5, 5.5, 6], 1, 0.5, 0.02)
```
"""
function invGaussianPsy(p::Real, midpoint::Real, slope::Real, guess::Real, lapse::Real)
    out = midpoint + sqrt(2*slope^2)*erfinv(2*(p-guess)/(1-guess-lapse)-1)
    return out
end

function invGaussianPsy(p::AbstractVector{T}, midpoint::Real, slope::Real, guess::Real, lapse::Real) where {T<:Real}
    out = midpoint .+ sqrt(2*slope^2)*erfinv.(2*(p .- guess)/(1-guess-lapse) .- 1)
    return out
end

function invGaussianPsy(p::Real, midpoint::AbstractVector{T}, slope::Real, guess::Real, lapse::Real) where {T<:Real}
    out = midpoint .+ sqrt(2*slope^2)*erfinv(2*(p-guess)/(1-guess-lapse)-1)
    return out
end

"""
Compute the Weibull psychometric function.

$(SIGNATURES)

##### Parameters

* `x`: Stimulus level(s).
* `midpoint`: Mid-point(s) of the psychometric function.
* `slope`: The slope of the psychometric function.
* `guess`: Lower limit of the psychometric function. Guess rate.
* `lapse`: Lapse rate.

##### Returns

* `pc`: The proportion correct at the stimulus level `x` for the psychometric function defined
    by the input parameters.
    
##### Examples

```julia
weibullPsy(2.5, 3, 2, 0.5, 0.001)
# for several x
weibullPsy([2.5, 3, 3.5], 3, 2, 0.5, 0.001)
# for several midpoints
weibullPsy(2.5, [3, 3.5, 4], 2, 0.5, 0.001)
```
"""
function weibullPsy(x::Real, midpoint::Real, slope::Real, guess::Real, lapse::Real)
    out = guess+(1-guess-lapse)*(1-exp(-(x/midpoint)^slope))
    return out
end

function weibullPsy(x::AbstractVector{T}, midpoint::Real, slope::Real, guess::Real, lapse::Real) where {T<:Real}
    out = guess .+ (1-guess-lapse)*(1 .- exp.(-(x/midpoint).^slope))
    return out
end

function weibullPsy(x::Real, midpoint::AbstractVector{T}, slope::Real, guess::Real, lapse::Real) where {T<:Real}
    out = guess .+ (1-guess-lapse)*(1 .- exp.(-(x./midpoint).^slope))
    return out
end

"""
Compute the inverse of the Weibull psychometric function.

$(SIGNATURES)

##### Parameters

* `p`: Proportion correct on the psychometric function.
* `midpoint`: Mid-point(s) of the psychometric function.
* `slope`: The slope of the psychometric function.
* `guess`: Lower limit of the psychometric function.
* `lapse`: The lapse rate.

##### Returns

* `x`: the stimulus level at which proportion correct equals `p` for the
    psychometric function defined by the input parameters.

##### Examples

```julia
invWeibullPsy(0.9, 5, 1, 0.5, 0.02)
# for several pc
invWeibullPsy([0.7, 0.8, 0.9], 5, 1, 0.5, 0.02)
#for several midpoints
invWeibullPsy(0.9, [5, 5.5, 6], 1, 0.5, 0.02)
```
    
"""
function invWeibullPsy(p::Real, midpoint::Real, slope::Real, guess::Real, lapse::Real)
    out = midpoint * ( (-log(1-(p-guess)/(1-guess-lapse)))^(1/slope) )
    return out
end

function invWeibullPsy(p::AbstractVector{T}, midpoint::Real, slope::Real, guess::Real, lapse::Real) where {T<:Real}
    out = midpoint * ( (-log.(1 .- (p .- guess)./(1-guess-lapse))).^(1/slope) )
    return out
end

function invWeibullPsy(p::Real, midpoint::AbstractVector{T}, slope::Real, guess::Real, lapse::Real) where {T<:Real}
    out = midpoint * ( (-log(1-(p-guess)/(1-guess-lapse)))^(1/slope) )
    return out
end

"""
Compute the gumbel psychometric function.

$(SIGNATURES)

##### Parameters

* `x`: Stimulus level(s).
* `midpoint`: Mid-point(s) of the psychometric function.
* `slope`: The slope of the psychometric function.
* `guess`: Lower limit of the psychometric function. Guess rate.
* `lapse`: Lapse rate.

##### Returns

* `pc`: The proportion correct at the stimulus level `x` for the psychometric function defined
    by the input parameters.
    
##### Examples

```julia
gumbelPsy(2.5, 3, 2, 0.5, 0.001)
# for several x
gumbelPsy([2.5, 3, 3.5], 3, 2, 0.5, 0.001)
# for several midpoints
gumbelPsy(2.5, [3, 3.5, 4], 2, 0.5, 0.001)

```
"""   
function gumbelPsy(x::Real, midpoint::Real, slope::Real, guess::Real, lapse::Real)
    out = guess + (1-guess-lapse) * (1-exp(-10^(slope*(x-midpoint))))
    return out
end

function gumbelPsy(x::AbstractVector{T}, midpoint::Real, slope::Real, guess::Real, lapse::Real) where {T<:Real}
    out = guess .+ (1-guess-lapse) * (1 .- exp.(-10 .^ (slope*(x .- midpoint))))
    return out
end

function gumbelPsy(x::Real, midpoint::AbstractVector{T}, slope::Real, guess::Real, lapse::Real) where {T<:Real}
    out = guess .+ (1-guess-lapse) * (1 .- exp.(-10 .^ (slope*(x .- midpoint))))
    return out
end

"""
Compute the inverse of the gumbel psychometric function.

$(SIGNATURES)

##### Parameters

* `p`: Proportion correct on the psychometric function.
* `midpoint`: Mid-point(s) of the psychometric function.
* `slope`: The slope of the psychometric function.
* `guess`: Lower limit of the psychometric function.
* `lapse`: The lapse rate.

##### Returns

* `x`: the stimulus level at which proportion correct equals `p` for the
    psychometric function defined by the input parameters.

##### Examples

```julia
invGumbelPsy(0.9, 5, 1, 0.5, 0.02)
# for several pc
invGumbelPsy([0.7, 0.8, 0.9], 5, 1, 0.5, 0.02)
#for several midpoints
invGumbelPsy(0.9, [5, 5.5, 6], 1, 0.5, 0.02)
```
"""
function invGumbelPsy(p::Real, midpoint::Real, slope::Real, guess::Real, lapse::Real)
    out = midpoint + (log10(-log(1 - (p-guess)/(1-guess-lapse))))/slope
    return out
end

function invGumbelPsy(p::AbstractVector{T}, midpoint::Real, slope::Real, guess::Real, lapse::Real) where {T<:Real}
    out = midpoint .+ (log10.(-log.(1 .- (p .- guess)/(1-guess-lapse))))/slope
    return out
end

function invGumbelPsy(p::Real, midpoint::AbstractVector{T}, slope::Real, guess::Real, lapse::Real) where {T<:Real}
    out = midpoint .+ (log10(-log(1 - (p-guess)/(1-guess-lapse))))/slope
    return out
end

"""
Compute the logistic psychometric function.

$(SIGNATURES)

##### Parameters

* `x`: Stimulus level(s).
* `midpoint`: Mid-point(s) of the psychometric function.
* `slope`: The slope of the psychometric function.
* `guess`: Lower limit of the psychometric function. Guess rate.
* `lapse`: Lapse rate.

##### Returns

* `pc`: The proportion correct at the stimulus level `x` for the psychometric function defined
    by the input parameters.
    
##### Examples

```julia
logisticPsy(2.5, 3, 2, 0.5, 0.001)
# for several x
logisticPsy([2.5, 3, 3.5], 3, 2, 0.5, 0.001)
# for several midpoints
logisticPsy(2.5, [3, 3.5, 4], 2, 0.5, 0.001)
```
"""
function logisticPsy(x::Real, midpoint::Real, slope::Real, guess::Real, lapse::Real)

    out = guess + (1-guess-lapse) *(1 ./ (1+exp(slope*(midpoint-x))))
    return out
end

function logisticPsy(x::AbstractVector{T}, midpoint::Real, slope::Real, guess::Real, lapse::Real) where {T<:Real}

    out = guess .+ (1-guess-lapse) *(1 ./ (1 .+ exp.(slope*(midpoint.-x))))
    return out
end

function logisticPsy(x::Real, midpoint::AbstractVector{T}, slope::Real, guess::Real, lapse::Real) where {T<:Real}

    out = guess .+ (1-guess-lapse) *(1 ./ (1 .+ exp.(slope*(midpoint.-x))))
    return out
end

function logisticPsy(x::Real, midpoint::AbstractArray{T,3}, slope::AbstractArray{T,3}, guess::Real, lapse::AbstractArray{T,3}) where {T<:Real}

    out = guess + (1-guess-lapse) .*(1 ./ (1+exp(slope.*(midpoint-x))))
    return out
end

"""
Compute the inverse of the logistic psychometric function.

$(SIGNATURES)

##### Parameters

* `p`: Proportion correct on the psychometric function.
* `midpoint`: Mid-point(s) of the psychometric function.
* `slope`: The slope of the psychometric function.
* `guess`: Lower limit of the psychometric function.
* `lapse`: The lapse rate.

##### Returns

* `x`: the stimulus level at which proportion correct equals `p` for the
    psychometric function defined by the input parameters.

##### Examples

```julia
invLogisticPsy(0.9, 5, 1, 0.5, 0.02)
# for several pc
invLogisticPsy([0.7, 0.8, 0.9], 5, 1, 0.5, 0.02)
#for several midpoints
invLogisticPsy(0.9, [5, 5.5, 6], 1, 0.5, 0.02)
```
    
"""
function invLogisticPsy(p::Real, midpoint::Real, slope::Real, guess::Real, lapse::Real)

    x = midpoint - (1/slope)*log((1-guess-lapse)./(p-guess) - 1)
    return x
end

function invLogisticPsy(p::AbstractVector{T}, midpoint::Real, slope::Real, guess::Real, lapse::Real) where {T<:Real}

    x = midpoint .- (1/slope)*log.((1-guess-lapse)./(p.-guess) .- 1)
    return x
end

function invLogisticPsy(p::Real, midpoint::AbstractVector{T}, slope::Real, guess::Real, lapse::Real) where {T<:Real}

    x = midpoint .- (1/slope)*log((1-guess-lapse)./(p-guess) - 1)
    return x
end

end #module
