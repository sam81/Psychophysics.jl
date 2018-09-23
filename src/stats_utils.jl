"""
Compute the geometric mean.

$(SIGNATURES)

##### Parameters

* `x`: Vector containing the values for which to compute the mean.

##### Returns

* `m`: The geometric mean.

##### Examples

```julia
geoMean([3, 75, 1000])
```
"""
function geoMean(x::AbstractVector{T}) where {T<:Real}
    if in(-1, sign.(x))
        error("Cannot compute geometric mean with negative values")
    end
    n = length(x)
    m = exp(sum(log.(x))/n)
    return m
end

"""
Compute a weighted geometric mean.

$(SIGNATURES)

##### Parameters
* `x`: Vector containing the values for which to compute the mean.
* `w`: Vector of weights (the same length as `x`).

##### Returns

* `wm`: The weighted geometric mean.

##### Examples
```julia
wGeoMean([5, 80, 150], [0.4, 0.2, 0.4])
```
"""
function wGeoMean(x::AbstractVector{T},
                  w::AbstractVector{P}) where {T<:Real, P<:Real}
    if in(-1, sign.(x))
        error("Cannot compute weighted geometric mean with negative values")
    end
    wm = exp(sum(w.*log.(x))/sum(w))
    return wm
end

"""
Compute the geometric standard deviation.

$(SIGNATURES)

##### Parameters

* `x`: Vector containing the values for which to compute the standard deviation.

##### Returns

`sd`: The geometric standard deviation.

##### Examples

```julia
geoSD([3, 75, 1000])
```
"""
function geoSD(x::AbstractVector{T}) where {T<:Real}
    if in(-1, sign.(x))
        error("Cannot compute geometric standard deviation with negative values")
    end
    out = exp(std(log.(x)))
    return out
end

"""
Compute the geometric standard error of the mean.

$(SIGNATURES)

##### Parameters

* `x`: Vector containing the values for which to compute the standard error.

##### Returns

`se`: The geometric standard error of the mean.

##### Examples

```julia
geoSE([3, 75, 1000])
```

"""
function geoSE(x::AbstractVector{T}) where {T<:Real}
    if in(-1, sign.(x))
        error("Cannot compute geometric standard error with negative values")
    end
    n = length(x)
    out = exp(sqrt(sum((log.(x) .- mean(log.(x))).^2) / ((n-1)* n)))
    return out
end

"""
Compute the standard error of the mean.

$(SIGNATURES)

##### Parameters

* `x`: Vector containing the values for which to compute the standard error.
* `removeNaN`: if true, NaN values will be removed from `x` before computing the standard error. Default is false.

##### Returns

`se`: The standard error of the mean.

##### Examples

```julia
SE([3, 8, 9])
SE([3, 8, NaN], removeNaN=false)
SE([3, 8, NaN], removeNaN=true)
```

"""
function SE(x::AbstractVector{T}; removeNaN::Bool=false) where {T<:Real}
    if removeNaN == true
         x = x[isnan.(x) .== false]
    end
    n = length(x)
    out = std(x) / sqrt(n)
    return(out)
end

function betaABFromMeanSTD(mean::Real, std::Real)

    if (mean <=0) | (mean >= 1)
        error("must have 0 < mean < 1")
    end
    if std <= 0
        error("sd must be > 0")
    end
    kappa = mean*(1-mean)/std^2 - 1
    if kappa <= 0
        error("invalid combination of mean and sd")
    end
    a = mean * kappa
    b = (1.0 - mean) * kappa

    return a, b
    
end


function generalizedBetaABFromMeanSTD(mu::Real, std::Real, xmin::Real, xmax::Real)
    ## see http://stats.stackexchange.com/questions/12232/calculating-the-parameters-of-a-beta-distribution-using-the-mean-and-variance
    
    lmbd = (((mu-xmin)*(xmax-mu))/std^2)-1
    a = lmbd*((mu-xmin)/(xmax-xmin))
    b = lmbd*((xmax-mu)/(xmax-xmin))

     return a,b

end


function gammaShRaFromMeanSD(mean::Real, sd::Real)
    if mean <=0
        error("mean must be > 0")
    end
    if sd <= 0
        error("sd must be > 0")
    end
    shape = (mean^2)/(sd^2)
    rate = mean/(sd^2)
    
    return shape, rate
end

function gammaShRaFromModeSD(mode::Real, sd::Real)
    if mode <=0
        error("mode must be > 0")
    end
    if sd <= 0
        error("sd must be > 0")
    end
    rate = (mode + sqrt(mode^2 + 4 * sd^2)) / (2 * sd^2)
    shape = 1 + mode * rate

    return shape, rate
end
