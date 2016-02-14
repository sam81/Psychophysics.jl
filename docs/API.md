Compute the geometric mean.

#####Parameters

* `x`: Vector containing the values for which to compute the mean.

#####Returns

* `m`: The geometric mean.

##### Examples

```julia
geoMean([3, 75, 1000])
```

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

Compute the geometric standard deviation.

##### Parameters

* `x`: Vector containing the values for which to compute the standard deviation.

##### Returns

`sd`: The geometric standard deviation.

##### Examples

```julia
geoSD([3, 75, 1000])
```

Compute the geometric standard error.

##### Parameters

* `x`: Vector containing the values for which to compute the standard error.

##### Returns

`se`: The geometric standard deviation.

##### Examples

```julia
geoSE([3, 75, 1000])
```


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
    

