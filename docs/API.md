# AudioUtils

## Exported

---

<a id="method__gaussianpsy.1" class="lexicon_definition"></a>
#### gaussianPsy(x::Real, midpoint::Real, slope::Real, guess::Real, lapse::Real) [¶](#method__gaussianpsy.1)
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
# for several x
gaussianPsy([2.5, 3, 3.5], 3, 2, 0.5, 0.001)
# for several midpoints
gaussianPsy(2.5, [3, 3.5, 4], 2, 0.5, 0.001)
```


*source:*
[AudioUtils/src/AudioUtils.jl:158](file:///home/sam/.julia/v0.3/AudioUtils/src/AudioUtils.jl)

---

<a id="method__geomean.1" class="lexicon_definition"></a>
#### geoMean{T<:Real}(x::AbstractArray{T<:Real, 1}) [¶](#method__geomean.1)
Compute the geometric mean.

#####Parameters

* `x`: Vector containing the values for which to compute the mean.

#####Returns

* `m`: The geometric mean.

##### Examples

```julia
geoMean([3, 75, 1000])
```


*source:*
[AudioUtils/src/AudioUtils.jl:46](file:///home/sam/.julia/v0.3/AudioUtils/src/AudioUtils.jl)

---

<a id="method__geosd.1" class="lexicon_definition"></a>
#### geoSD{T<:Real}(x::AbstractArray{T<:Real, 1}) [¶](#method__geosd.1)
Compute the geometric standard deviation.

##### Parameters

* `x`: Vector containing the values for which to compute the standard deviation.

##### Returns

`sd`: The geometric standard deviation.

##### Examples

```julia
geoSD([3, 75, 1000])
```


*source:*
[AudioUtils/src/AudioUtils.jl:97](file:///home/sam/.julia/v0.3/AudioUtils/src/AudioUtils.jl)

---

<a id="method__geose.1" class="lexicon_definition"></a>
#### geoSE{T<:Real}(x::AbstractArray{T<:Real, 1}) [¶](#method__geose.1)
Compute the geometric standard error.

##### Parameters

* `x`: Vector containing the values for which to compute the standard error.

##### Returns

`se`: The geometric standard deviation.

##### Examples

```julia
geoSE([3, 75, 1000])
```



*source:*
[AudioUtils/src/AudioUtils.jl:123](file:///home/sam/.julia/v0.3/AudioUtils/src/AudioUtils.jl)

---

<a id="method__gumbelpsy.1" class="lexicon_definition"></a>
#### gumbelPsy(x::Real, midpoint::Real, slope::Real, guess::Real, lapse::Real) [¶](#method__gumbelpsy.1)
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
# for several x
gumbelPsy([2.5, 3, 3.5], 3, 2, 0.5, 0.001)
# for several midpoints
gumbelPsy(2.5, [3, 3.5, 4], 2, 0.5, 0.001)

```


*source:*
[AudioUtils/src/AudioUtils.jl:332](file:///home/sam/.julia/v0.3/AudioUtils/src/AudioUtils.jl)

---

<a id="method__invgaussianpsy.1" class="lexicon_definition"></a>
#### invGaussianPsy(p::Real, midpoint::Real, slope::Real, guess::Real, lapse::Real) [¶](#method__invgaussianpsy.1)
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
# for several pc
invGaussianPsy([0.7, 0.8, 0.9], 5, 1, 0.5, 0.02)
#for several midpoints
invGaussianPsy(0.9, [5, 5.5, 6], 1, 0.5, 0.02)
```
    


*source:*
[AudioUtils/src/AudioUtils.jl:204](file:///home/sam/.julia/v0.3/AudioUtils/src/AudioUtils.jl)

---

<a id="method__invgumbelpsy.1" class="lexicon_definition"></a>
#### invGumbelPsy(p::Real, midpoint::Real, slope::Real, guess::Real, lapse::Real) [¶](#method__invgumbelpsy.1)
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
# for several pc
invGumbelPsy([0.7, 0.8, 0.9], 5, 1, 0.5, 0.02)
#for several midpoints
invGumbelPsy(0.9, [5, 5.5, 6], 1, 0.5, 0.02)
```
    


*source:*
[AudioUtils/src/AudioUtils.jl:375](file:///home/sam/.julia/v0.3/AudioUtils/src/AudioUtils.jl)

---

<a id="method__invlogisticpsy.1" class="lexicon_definition"></a>
#### invLogisticPsy(p::Real, midpoint::Real, slope::Real, guess::Real, lapse::Real) [¶](#method__invlogisticpsy.1)
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
# for several pc
invLogisticPsy([0.7, 0.8, 0.9], 5, 1, 0.5, 0.02)
#for several midpoints
invLogisticPsy(0.9, [5, 5.5, 6], 1, 0.5, 0.02)
```
    


*source:*
[AudioUtils/src/AudioUtils.jl:463](file:///home/sam/.julia/v0.3/AudioUtils/src/AudioUtils.jl)

---

<a id="method__invweibullpsy.1" class="lexicon_definition"></a>
#### invWeibullPsy(p::Real, midpoint::Real, slope::Real, guess::Real, lapse::Real) [¶](#method__invweibullpsy.1)
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
# for several pc
invWeibullPsy([0.7, 0.8, 0.9], 5, 1, 0.5, 0.02)
#for several midpoints
invWeibullPsy(0.9, [5, 5.5, 6], 1, 0.5, 0.02)
```
    


*source:*
[AudioUtils/src/AudioUtils.jl:289](file:///home/sam/.julia/v0.3/AudioUtils/src/AudioUtils.jl)

---

<a id="method__logisticpsy.1" class="lexicon_definition"></a>
#### logisticPsy(x::Real, midpoint::Real, slope::Real, guess::Real, lapse::Real) [¶](#method__logisticpsy.1)
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
# for several x
logisticPsy([2.5, 3, 3.5], 3, 2, 0.5, 0.001)
# for several midpoints
logisticPsy(2.5, [3, 3.5, 4], 2, 0.5, 0.001)
```


*source:*
[AudioUtils/src/AudioUtils.jl:417](file:///home/sam/.julia/v0.3/AudioUtils/src/AudioUtils.jl)

---

<a id="method__wgeomean.1" class="lexicon_definition"></a>
#### wGeoMean{T<:Real, P<:Real}(x::AbstractArray{T<:Real, 1}, w::AbstractArray{P<:Real, 1}) [¶](#method__wgeomean.1)
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


*source:*
[AudioUtils/src/AudioUtils.jl:71](file:///home/sam/.julia/v0.3/AudioUtils/src/AudioUtils.jl)

---

<a id="method__weibullpsy.1" class="lexicon_definition"></a>
#### weibullPsy(x::Real, midpoint::Real, slope::Real, guess::Real, lapse::Real) [¶](#method__weibullpsy.1)
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
# for several x
weibullPsy([2.5, 3, 3.5], 3, 2, 0.5, 0.001)
# for several midpoints
weibullPsy(2.5, [3, 3.5, 4], 2, 0.5, 0.001)
```


*source:*
[AudioUtils/src/AudioUtils.jl:246](file:///home/sam/.julia/v0.3/AudioUtils/src/AudioUtils.jl)

