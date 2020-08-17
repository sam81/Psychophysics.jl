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


################################
## deltaLToWeberFracdB
################################
"""
Convert the delta L measure of intensity discrimination to the Weber fraction expressed in dB

$(SIGNATURES)

##### Parameters

* `deltaL`: delta L

##### Returns

* `WdB`: Weber fraction expressed in dB

##### References

.. [GY] Grantham, D. W., & Yost, W. A. (1982). Measures of intensity discrimination. The Journal of the Acoustical Society of America, 72(2), 406–410. https://doi.org/10.1121/1.388092
.. [P] Plack, C. J. (2014). The sense of hearing (Second edition). New York: Psychology Press.

##### Examples

```julia
deltaLToWeberFracdB(2)
deltaLToWeberFracdB(0.5)
```
"""
function deltaLToWeberFracdB(deltaL::Real)
    WdB = 10*log10(10^(deltaL/10)-1)
    
    return(WdB)
end 

"""
Convert the Weber fraction expressed in dB measure of intensity discrimination to the delta L measure of intensity discrimination

$(SIGNATURES)

##### Parameters

* `WdB`: Weber fraction expressed in dB

##### Returns

* `deltaL`: delta L

##### References

.. [GY] Grantham, D. W., & Yost, W. A. (1982). Measures of intensity discrimination. The Journal of the Acoustical Society of America, 72(2), 406–410. https://doi.org/10.1121/1.388092
.. [P] Plack, C. J. (2014). The sense of hearing (Second edition). New York: Psychology Press.

##### Examples

```julia
weberFracdBToDeltaL(4.744)
weberFracdBToDeltaL(-5.868)
```
"""
function weberFracdBToDeltaL(W::Real)
    deltaL = 10*log10(10^(W/10)+1)

    return(deltaL)
end


