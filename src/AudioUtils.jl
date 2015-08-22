## The MIT License (MIT)

## Copyright (c) 2013-2015 Samuele Carcagno <sam.carcagno@gmail.com>

## Permission is hereby granted, free of charge, to any person obtaining a copy
## of this software and associated documentation files (the "Software"), to deal
## in the Software without restriction, including without limitation the rights
## to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
## copies of the Software, and to permit persons to whom the Software is
## furnished to do so, subject to the following conditions:

## The above copyright notice and this permission notice shall be included in
## all copies or substantial portions of the Software.

## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
## THE SOFTWARE.


module AudioUtils

export gaussianPsy, geoMean, geoSD, geoSE, gumbelPsy, invGaussianPsy, invGumbelPsy, invLogisticPsy, invWeibullPsy, logisticPsy, weibullPsy, wGeoMean

VERSION < v"0.4-" && using Docile

@doc doc"""
Compute the geometric mean.

#####Parameters

* `x`: Vector containing the values for which to compute the mean.

#####Returns

* `m`: The geometric mean.

##### Examples

```julia
geoMean([3, 75, 1000])
```
"""->
function geoMean{T<:Real}(x::AbstractVector{T})
    n = length(x)
    m = exp(sum(log(x))/n)
  return(m)
end

@doc doc"""
Compute a weighted geometric mean.

##### Parameters
* `x`: Vector containing the values for which to compute the mean.
* `w`: Vector of weights (the same length as `x`).

##### Returns

* `wm`: The weighted geometric mean.

##### Examples
```julia
wGeoMean([5, 80, 150], [0.4, 0.2, 0.4])
```
"""->
function wGeoMean{T<:Real, P<:Real}(x::AbstractVector{T},
                                    w::AbstractVector{P})
  wm = exp(sum(w.*log(x))/sum(w))
  return(wm)
end

@doc doc"""
Compute the geometric standard deviation.

##### Parameters

* `x`: Vector containing the values for which to compute the standard deviation.

##### Returns

`sd`: The geometric standard deviation.

##### Examples

```julia
geoSD([3, 75, 1000])
```
"""->
function geoSD{T<:Real}(x::AbstractVector{T})
    out = exp(std(log(x)))
    return(out)
end

@doc doc"""
Compute the geometric standard error.

##### Parameters

* `x`: Vector containing the values for which to compute the standard error.

##### Returns

`se`: The geometric standard deviation.

##### Examples

```julia
geoSE([3, 75, 1000])
```

"""->
function geoSE{T<:Real}(x::AbstractVector{T})
  n = length(x)
  out = exp(sqrt(sum((log(x) - mean(log(x)))^2) / ((n-1)* n)))
  return(out)
end

@doc doc"""
Compute the gaussian psychometric function.

##### Parameters

* `x`: Stimulus level(s).
* `midpoint`: Mid-point(s) of the psychometric function.
* `slope`: The slope of the psychometric function.
* `guess`: Lower limit of the psychometric function. Guess rate.
* `lapse`: Lapse rate.

##### Returns

* `pc`: The percent correct at the stimulus level `x` for the psychometric function defined
    by the input parameters.
    
##### Examples

```julia
gaussianPsy(2.5, 3, 2, 0.5, 0.001)
```
"""->

function gaussianPsy(x::Real, midpoint::Real, slope::Real, guess::Real, lapse::Real)
    # as in UML toolbox
    out = guess+(1-guess-lapse)*(1+erf((x-midpoint)/sqrt(2*slope^2)))/2
    return out
end

function gaussianPsy{T<:Real}(x::AbstractVector{T}, midpoint::Real, slope::Real, guess::Real, lapse::Real)
    # as in UML toolbox
    out = guess+(1-guess-lapse)*(1+erf((x-midpoint)/sqrt(2*slope^2)))/2
    return out
end

function gaussianPsy{T<:Real}(x::Real, midpoint::AbstractVector{T}, slope::Real, guess::Real, lapse::Real)
    # as in UML toolbox
    out = guess+(1-guess-lapse)*(1+erf((x-midpoint)/sqrt(2*slope^2)))/2
    return out
end

@doc doc"""
Compute the inverse of the gaussian psychometric function.

##### Parameters

* `p`: Proportion correct on the psychometric function.
* `midpoint`: Mid-point(s) of the psychometric function.
* `slope`: The slope of the psychometric function.
* `guess`: Lower limit of the psychometric function.
* `lapse`: The lapse rate.

##### Returns

* `x`: the stimulus level at which percent proportion equals `p` for the
    psychometric function defined by the input parameters.

##### Examples

```julia
invGaussianPsy(0.9, 5, 1, 0.5, 0.02)
```
    
"""->

function invGaussianPsy(p::Real, midpoint::Real, slope::Real, guess::Real, lapse::Real)
    out = midpoint + sqrt(2*slope^2)*erfinv(2*(p-guess)/(1-guess-lapse)-1)
    return out
end

function invGaussianPsy{T<:Real}(p::AbstractVector{T}, midpoint::Real, slope::Real, guess::Real, lapse::Real)
    out = midpoint + sqrt(2*slope^2)*erfinv(2*(p-guess)/(1-guess-lapse)-1)
    return out
end

function invGaussianPsy{T<:Real}(p::Real, midpoint::AbstractVector{T}, slope::Real, guess::Real, lapse::Real)
    out = midpoint + sqrt(2*slope^2)*erfinv(2*(p-guess)/(1-guess-lapse)-1)
    return out
end

@doc doc"""
Compute the Weibull psychometric function.

##### Parameters

* `x`: Stimulus level(s).
* `midpoint`: Mid-point(s) of the psychometric function.
* `slope`: The slope of the psychometric function.
* `guess`: Lower limit of the psychometric function. Guess rate.
* `lapse`: Lapse rate.

##### Returns

* `pc`: The percent correct at the stimulus level `x` for the psychometric function defined
    by the input parameters.
    
##### Examples

```julia
weibullPsy(2.5, 3, 2, 0.5, 0.001)
```
"""->

function weibullPsy(x::Real, midpoint::Real, slope::Real, guess::Real, lapse::Real)
    out = guess+(1-guess-lapse)*(1-exp(-(x/midpoint)^slope))
    return out
end

function weibullPsy{T<:Real}(x::AbstractVector{T}, midpoint::Real, slope::Real, guess::Real, lapse::Real)
    out = guess+(1-guess-lapse)*(1-exp(-(x/midpoint).^slope))
    return out
end

function weibullPsy{T<:Real}(x::Real, midpoint::AbstractVector{T}, slope::Real, guess::Real, lapse::Real)
    out = guess+(1-guess-lapse)*(1-exp(-(x./midpoint).^slope))
    return out
end

@doc doc"""
Compute the inverse of the Weibull psychometric function.

##### Parameters

* `p`: Proportion correct on the psychometric function.
* `midpoint`: Mid-point(s) of the psychometric function.
* `slope`: The slope of the psychometric function.
* `guess`: Lower limit of the psychometric function.
* `lapse`: The lapse rate.

##### Returns

* `x`: the stimulus level at which percent proportion equals `p` for the
    psychometric function defined by the input parameters.

##### Examples

```julia
invWeibullPsy(0.9, 5, 1, 0.5, 0.02)
```
    
"""->

function invWeibullPsy(p::Real, midpoint::Real, slope::Real, guess::Real, lapse::Real)
    out = midpoint * ( (-log(1-(p-guess)/(1-guess-lapse)))^(1/slope) )
    return out
end

function invWeibullPsy{T<:Real}(p::AbstractVector{T}, midpoint::Real, slope::Real, guess::Real, lapse::Real)
    out = midpoint * ( (-log(1-(p-guess)./(1-guess-lapse))).^(1/slope) )
    return out
end

function invWeibullPsy{T<:Real}(p::Real, midpoint::AbstractVector{T}, slope::Real, guess::Real, lapse::Real)
    out = midpoint * ( (-log(1-(p-guess)/(1-guess-lapse)))^(1/slope) )
    return out
end

@doc doc"""
Compute the gumbel psychometric function.

##### Parameters

* `x`: Stimulus level(s).
* `midpoint`: Mid-point(s) of the psychometric function.
* `slope`: The slope of the psychometric function.
* `guess`: Lower limit of the psychometric function. Guess rate.
* `lapse`: Lapse rate.

##### Returns

* `pc`: The percent correct at the stimulus level `x` for the psychometric function defined
    by the input parameters.
    
##### Examples

```julia
gumbelPsy(2.5, 3, 2, 0.5, 0.001)
```
"""->
    
function gumbelPsy(x::Real, midpoint::Real, slope::Real, guess::Real, lapse::Real)
    out = guess + (1-guess-lapse) * (1-exp(-10^(slope*(x-midpoint))))
    return out
end

function gumbelPsy{T<:Real}(x::AbstractVector{T}, midpoint::Real, slope::Real, guess::Real, lapse::Real)
    out = guess + (1-guess-lapse) * (1-exp(-10.^(slope*(x-midpoint))))
    return out
end

function gumbelPsy{T<:Real}(x::Real, midpoint::AbstractVector{T}, slope::Real, guess::Real, lapse::Real)
    out = guess + (1-guess-lapse) * (1-exp(-10.^(slope*(x-midpoint))))
    return out
end

@doc doc"""
Compute the inverse of the gumbel psychometric function.

##### Parameters

* `p`: Proportion correct on the psychometric function.
* `midpoint`: Mid-point(s) of the psychometric function.
* `slope`: The slope of the psychometric function.
* `guess`: Lower limit of the psychometric function.
* `lapse`: The lapse rate.

##### Returns

* `x`: the stimulus level at which percent proportion equals `p` for the
    psychometric function defined by the input parameters.

##### Examples

```julia
invGumbelPsy(0.9, 5, 1, 0.5, 0.02)
```
    
"""->

function invGumbelPsy(p::Real, midpoint::Real, slope::Real, guess::Real, lapse::Real)
    out = midpoint + (log10(-log(1 - (p-guess)/(1-guess-lapse))))/slope
    return out
end

function invGumbelPsy{T<:Real}(p::AbstractVector{T}, midpoint::Real, slope::Real, guess::Real, lapse::Real)
    out = midpoint + (log10(-log(1 - (p-guess)/(1-guess-lapse))))/slope
    return out
end

function invGumbelPsy{T<:Real}(p::Real, midpoint::AbstractVector{T}, slope::Real, guess::Real, lapse::Real)
    out = midpoint + (log10(-log(1 - (p-guess)/(1-guess-lapse))))/slope
    return out
end

@doc doc"""
Compute the logistic psychometric function.

##### Parameters

* `x`: Stimulus level(s).
* `midpoint`: Mid-point(s) of the psychometric function.
* `slope`: The slope of the psychometric function.
* `guess`: Lower limit of the psychometric function. Guess rate.
* `lapse`: Lapse rate.

##### Returns

* `pc`: The percent correct at the stimulus level `x` for the psychometric function defined
    by the input parameters.
    
##### Examples

```julia
logisticPsy(2.5, 3, 2, 0.5, 0.001)
```
"""->

function logisticPsy(x::Real, midpoint::Real, slope::Real, guess::Real, lapse::Real)

    out = guess + (1-guess-lapse) *(1./(1+exp(slope*(midpoint-x))))
    return out
end

function logisticPsy{T<:Real}(x::AbstractVector{T}, midpoint::Real, slope::Real, guess::Real, lapse::Real)

    out = guess + (1-guess-lapse) *(1./(1+exp(slope*(midpoint-x))))
    return out
end

function logisticPsy{T<:Real}(x::Real, midpoint::AbstractVector{T}, slope::Real, guess::Real, lapse::Real)

    out = guess + (1-guess-lapse) *(1./(1+exp(slope*(midpoint-x))))
    return out
end

@doc doc"""
Compute the inverse of the logistic psychometric function.

##### Parameters

* `p`: Proportion correct on the psychometric function.
* `midpoint`: Mid-point(s) of the psychometric function.
* `slope`: The slope of the psychometric function.
* `guess`: Lower limit of the psychometric function.
* `lapse`: The lapse rate.

##### Returns

* `x`: the stimulus level at which percent proportion equals `p` for the
    psychometric function defined by the input parameters.

##### Examples

```julia
invLogisticPsy(0.9, 5, 1, 0.5, 0.02)
```
    
"""->
function invLogisticPsy(p::Real, midpoint::Real, slope::Real, guess::Real, lapse::Real)

    x = midpoint - (1/slope)*log((1-guess-lapse)./(p-guess) - 1)
    return x
end

function invLogisticPsy{T<:Real}(p::AbstractVector{T}, midpoint::Real, slope::Real, guess::Real, lapse::Real)

    x = midpoint - (1/slope)*log((1-guess-lapse)./(p-guess) - 1)
    return x
end

function invLogisticPsy{T<:Real}(p::Real, midpoint::AbstractVector{T}, slope::Real, guess::Real, lapse::Real)

    x = midpoint - (1/slope)*log((1-guess-lapse)./(p-guess) - 1)
    return x
end

end #module
