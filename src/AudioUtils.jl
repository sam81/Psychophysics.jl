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

export geoMean, geoSd, geoSe, invLogisticPsy, logisticPsy, se, wGeoMean

VERSION < v"0.4-" && using Docile


function geoMean(x)
    n = length(x)
    m = exp(sum(log(x))/n)
  return(m)
end


#function to compute a weighted geometric mean
# x is the vector containing the values for which to find the mean
# and w is the vector of weights (the same length as x)
function wGeoMean{T<:Real, P<:Real}(x::AbstractVector{T},
                                    w::AbstractVector{P})
  wm = exp(sum(w*log(x))/sum(w))
  return(wm)
end

function geoSd{T<:Real}(x::AbstractVector{T})
    out = exp(std(log(x)))
    return(out)
end

function geoSe{T<:Real}(x::AbstractVector{T})
  n = length(x)
  out = exp(sqrt(sum((log(x) - mean(log(x)))^2) / ((n-1)* n)))
  return(out)
end



@doc doc"""
Compute the logistic psychometric function.

##### Parameters

* `x`: Stimulus level(s).
* `midpoint`: Mid-point(s) of the psychometric function.
* `slope`: The slope of the psychometric function.
* `guess`: Lower limit of the psychometric function. Guess rate.
* `lapse`: Lapse rate.
    
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
