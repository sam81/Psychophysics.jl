Compute the gaussian psychometric function.

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

Compute the inverse of the gaussian psychometric function.

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
    

Compute the Weibull psychometric function.

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

Compute the inverse of the Weibull psychometric function.

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
    

Compute the gumbel psychometric function.

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

Compute the inverse of the gumbel psychometric function.

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
    

Compute the logistic psychometric function.

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

Compute the inverse of the logistic psychometric function.

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
    

