#   Copyright (C) 2016 Samuele Carcagno <sam.carcagno@gmail.com>
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

# This is a Julia port of the UML method of Shen and Richards http://hearlab.ss.uci.edu/UML/uml.html
# - Shen, Y., & Richards, V. (2012). A maximum-likelihood procedure for estimating psychometric functions: Thresholds, slopes, and lapses of attention. The Journal of the Acoustical Society of America, 132, 957–967.
# - Shen, Y., Dai, W., & Richards, V. M. (2014). A MATLAB toolbox for the efficient estimation of the psychometric function using the updated maximum-likelihood adaptive procedure. Behavior Research Methods, 13–26.

using Distributions, Optim

#using Psychophysics
include("ndgrid.jl")

function setupUML(;model::ASCIIString="logistic",
                  swptRule::ASCIIString="up-down",
                  nDown::Int=2,
                  centTend::ASCIIString="mean",
                  stimScale::ASCIIString="linear",
                  x0::Real=NaN,
                  xLim::Tuple{Real,Real}=(-10.0, 10.0),
                  alphaLim::Tuple{Real,Real}=(-10.0,10.0),
                  alphaStep::Real=1,
                  alphaSpacing::ASCIIString="linear",
                  alphaDist::ASCIIString="uniform",
                  alphaMu::Real=0,
                  alphaSTD::Real=20,
    betaLim::Tuple{Real,Real}=(0.1,10),
    betaStep::Real=0.1,
    betaSpacing::ASCIIString="linear",
    betaDist::ASCIIString="uniform",
    betaMu::Real=1,
    betaSTD::Real=2,
    gamma::Real=0.5,
    lambdaLim::Tuple{Real,Real}=(0,0.2),
    lambdaStep::Real=0.01,
    lambdaSpacing::ASCIIString="linear",
    lambdaDist::ASCIIString="uniform",
    lambdaMu::Real=0,
    lambdaSTD::Real=0.1,
    suggestedLambdaSwpt::Real=10.0,
    lambdaSwptPC::Real=0.99)

    UML = Dict{ASCIIString, Any}()
    UML["par"] = Dict{ASCIIString, Any}()

    UML["par"]["swptRule"] = swptRule
    UML["par"]["nDown"] = nDown
    UML["par"]["method"] = centTend
    UML["par"]["model"] = model
    UML["par"]["x0"] = x0
    UML["par"]["x"] = Dict{ASCIIString, Any}()
    UML["par"]["x"]["limits"] = xLim
    #UML["par"]["x"]["step"] = xStep
    UML["par"]["stimScale"] = stimScale
    UML["par"]["x"]["spacing"] = "linear"

    UML["par"]["alpha"] = Dict{ASCIIString, Any}()
    UML["par"]["alpha"]["limits"] = alphaLim
    UML["par"]["alpha"]["step"] = alphaStep
    #UML["par"]["alpha"]["scale"] = alphaScale
    UML["par"]["alpha"]["spacing"] = alphaSpacing
    UML["par"]["alpha"]["dist"] = alphaDist
    UML["par"]["alpha"]["mu"] = alphaMu
    UML["par"]["alpha"]["std"] = alphaSTD

    UML["par"]["beta"] = Dict{ASCIIString, Any}()
    UML["par"]["beta"]["limits"] = betaLim
    UML["par"]["beta"]["step"] = betaStep
    #UML["par"]["beta"]["scale"] = betaScale
    UML["par"]["beta"]["spacing"] = betaSpacing
    UML["par"]["beta"]["dist"] = betaDist
    UML["par"]["beta"]["mu"] = betaMu
    UML["par"]["beta"]["std"] = betaSTD

    #UML["par"]["gamma"] = gamma

    UML["par"]["lambda"] = Dict{ASCIIString, Any}()
    UML["par"]["lambda"]["limits"] = lambdaLim
    UML["par"]["lambda"]["step"] = lambdaStep
    #UML["par"]["lambda"]["scale"] = lambdaScale
    UML["par"]["lambda"]["spacing"] = lambdaSpacing
    UML["par"]["lambda"]["dist"] = lambdaDist
    UML["par"]["lambda"]["mu"] = lambdaMu
    UML["par"]["lambda"]["std"] = lambdaSTD

    UML["par"]["suggestedLambdaSwpt"] = suggestedLambdaSwpt
    UML["par"]["lambdaSwptPC"] = lambdaSwptPC

    if stimScale == "logarithmic"
        UML["par"]["x0"] = log(x0)
        UML["par"]["x"]["limits"] = log(xLim)
        UML["par"]["alpha"]["limits"] = log(alphaLim)
        UML["par"]["alpha"]["step"] = log(alphaStep)
        UML["par"]["alpha"]["mu"] = log(alphaMu)
        UML["par"]["alpha"]["std"] = log(alphaSTD)
        UML["par"]["alpha"]["spacing"] = "linear" #on a log scale
        UML["par"]["suggestedLambdaSwpt"] = log(UML["par"]["suggestedLambdaSwpt"])
    end

    UML = setP0(UML)
    UML["x"] = (Real)[]
    UML["xnext"] = copy(UML["par"]["x0"])
    UML["r"] = (Int)[]
    UML["n"] = 0
    UML["gamma"] = gamma

    UML["swpts_idx"] = (Int)[]
    if length(UML["alpha"]) > 1 #alpha is not fixed, estimate it
        push!(UML["swpts_idx"], 2)
    end
    if length(UML["beta"]) > 1 #beta is not fixed, estimate it
        push!(UML["swpts_idx"], 1)
        push!(UML["swpts_idx"], 3)
    end
    if length(UML["lambda"]) > 1 #lambda is not fixed, estimate it
        push!(UML["swpts_idx"], 4)
    end

    sort!(UML["swpts_idx"])
    UML["nsteps"] = length(UML["swpts_idx"])
    UML["step_flag"] = 0
    UML["track_direction"] = 0
    UML["rev_flag"] = (Int)[]
    UML["nrev"] = 0

    if UML["par"]["x0"] == UML["par"]["x"]["limits"][1]
        UML["current_step"] = 1
    elseif UML["par"]["x0"] == UML["par"]["x"]["limits"][2]
        UML["current_step"] = UML["nsteps"]
    else
        UML["current_step"] = ceil(Int, UML["nsteps"]/2)
    end


    return UML

end


function setP0(UML)
    UML["alpha"] = setParSpace(UML["par"]["alpha"])
    UML["beta"] = setParSpace(UML["par"]["beta"])
    UML["lambda"] = setParSpace(UML["par"]["lambda"])

    UML["a"], UML["b"], UML["l"] = meshgrid(UML["alpha"], UML["beta"], UML["lambda"])

    A = setPrior(UML["a"], UML["par"]["alpha"])
    B = setPrior(UML["b"], UML["par"]["beta"])
    L = setPrior(UML["l"], UML["par"]["lambda"])

    UML["p"] = log(prepare_prob(A.*B.*L))

    return UML
    
end

function setParSpace(s)
    if s["spacing"] == "linear"
        space = collect(s["limits"][1]:s["step"]:s["limits"][2])
    elseif s["spacing"] == "logarithmic"
        space = 10.^collect(log10(s["limits"][1]):log10(s["step"]):log10(s["limits"][2]))
    end
    space = map(Float64, space)
    return space
end

function setPrior(phi, s)
    if s["dist"] == "normal"
        if s["spacing"] == "linear"
            p0  = pdf(Normal(s["mu"], s["std"]), phi)
        elseif s["spacing"] == "logarithmic"
            p0  = pdf(Normal(log(s["mu"]), log(s["std"])), log(phi))
        end
    elseif s["dist"] == "uniform"
        p0 = ones(size(phi))

#     elif s["dist"] == "Gamma":
#         gShape, gRate = gammaShRaFromModeSD(s["mu"], s["std"])
#         if s["spacing"] == "Linear":
#             p0 = stats.gamma.pdf(phi, gShape, loc=0, scale=1/gRate)
#         elif s["spacing"] == "Logarithmic":
#             p0 = stats.gamma.pdf(log(phi), gShape, loc=0, scale=1/gRate)
#     elseif s["dist"] == "beta"
#         if s["spacing"] == "linear"
#             a,b=betaABFromMeanSTD(s["mu"], s["std"])
#             p0  = stats.beta.pdf(phi, a=a, b=b)
#         elseif s["spacing"] == "Logarithmic":
#             a,b=betaABFromMeanSTD(log(s["mu"]), log(s["std"]))
#             p0  = stats.beta.pdf(phi, a=a, b=b)
#         p0[np.isinf(p0)] = scipy.stats.beta.pdf(np.finfo(0.1).eps, a, b)
#         p0[np.isneginf(p0)] = scipy.stats.beta.pdf(np.finfo(0.1).eps, a, b)
#     elif s["dist"] == "Generalized Beta":
#         if s["spacing"] == "Linear":
#             a,b=generalizedBetaABFromMeanSTD(s["mu"], s["std"], s["limits"][0], s["limits"][1])
#             p0  = stats.beta.pdf(phi, a=a, b=b, loc=s["limits"][0], scale=s["limits"][1]-s["limits"][0])
#         elif s["spacing"] == "Logarithmic":
#             a,b=generalizedBetaABFromMeanSTD(log(s["mu"]), log(s["std"]), log(s["limits"][0]), log(s["limits"][1]))
#             p0  = stats.beta.pdf(phi, a=a, b=b, loc=log(s["limits"][0]), scale=log(s["limits"][1])-log(s["limits"][0]))
#         p0[np.isinf(p0)] = scipy.stats.beta.pdf(np.finfo(0.1).eps, a, b)
#         p0[np.isneginf(p0)] = scipy.stats.beta.pdf(np.finfo(0.1).eps, a, b)
#     elif s["dist"] == "t":
#         if s["spacing"] == "Linear":
#             p0  = stats.t.pdf(phi, loc=s["mu"], scale=s["std"], df=1)
#         elif s["spacing"] == "Logarithmic":
        #             p0  = stats.t.pdf(log(phi), loc=log(s["mu"]), scale=log(s["std"]), df=1)
    end
            
     return p0
end

function prepare_prob(p)
    p = p*(1-1e-10)
    p = p/sum(p)

    return p
end


function UML_update(UML, r)
    UML["n"] = UML["n"] +1
    push!(UML["x"], UML["xnext"])
    push!(UML["r"], r)

    if UML["par"]["model"] == "logistic"
        UML["p"] = UML["p"] + 
                   log(prepare_prob(logisticPsy(UML["xnext"], UML["a"], UML["b"], UML["gamma"], UML["l"])).^r) + 
                   log(prepare_prob(1-logisticPsy(UML["xnext"], UML["a"], UML["b"], UML["gamma"], UML["l"])).^(1-r))
    elseif UML["par"]["model"] == "gaussian"
        UML["p"] = UML["p"] + 
                   log(prepare_prob(gaussianPsy(UML["xnext"], UML["a"], UML["b"], UML["gamma"], UML["l"])).^r) + 
                   log(prepare_prob(1-gaussianPsy(UML["xnext"], UML["a"], UML["b"], UML["gamma"], UML["l"])).^(1-r))
    elseif UML["par"]["model"] == "weibull"
        UML["p"] = UML["p"] + 
                   log(prepare_prob(weibullPsy(UML["xnext"], UML["a"], UML["b"], UML["gamma"], UML["l"])).^r) + 
        log(prepare_prob(1-weibullPsy(UML["xnext"], UML["a"], UML["b"], UML["gamma"], UML["l"])).^(1-r))
    end


    UML["p"] = UML["p"]-maximum(UML["p"])#np.max(np.max(np.max(UML["p"])))
  
    if UML["par"]["method"] == "mode"
        
        idx = indmax(UML["p"])
        if UML["n"] < 2
            UML["phi"] = zeros(1,4)
            UML["phi"][1, 1:4] = [UML["a"][idx], UML["b"][idx], UML["gamma"], UML["l"][idx]]
        else
            tmp = zeros(1,4)
            tmp[1, 1:4] = UML["phi"], [UML["a"][idx], UML["b"][idx], UML["gamma"], UML["l"][idx]]
            UML["phi"] = vcat(UML["phi"], tmp)
        end
    elseif UML["par"]["method"] == "mean"
        pdf_tmp = exp(UML["p"])
        pdf_tmp = pdf_tmp/sum(pdf_tmp)
        alpha_est_tmp = sum(pdf_tmp.*UML["a"])
        beta_est_tmp = sum(pdf_tmp.*UML["b"])
        lambda_est_tmp = sum(pdf_tmp.*UML["l"])

        if UML["n"] < 2
            UML["phi"] = zeros(1,4)
            UML["phi"][1, 1:4] = [alpha_est_tmp, beta_est_tmp, UML["gamma"], lambda_est_tmp]
        else
            tmp = zeros(1,4)
            tmp[1, 1:4] = [alpha_est_tmp, beta_est_tmp, UML["gamma"], lambda_est_tmp]
            UML["phi"] = vcat(UML["phi"], tmp)
        end
    end

    if UML["par"]["stimScale"] == "logarithmic"
        UML["est_midpoint"] = exp(UML["phi"][end, 1])
    else
        UML["est_midpoint"] = UML["phi"][end, 1]
    end

    UML["est_slope"] = UML["phi"][end, 2]
    UML["est_lapse"] = UML["phi"][end, 4]

    if UML["par"]["model"] == "logistic"
        swpt = logit_sweetpoints(UML["phi"][end,:], UML["par"]["alpha"]["limits"][1], UML["par"]["alpha"]["limits"][2])

    elseif UML["par"]["model"] == "gaussian"
        swpt = gaussian_sweetpoints(UML["phi"][end,:])
    elseif UML["par"]["model"] == "weibull"
        swpt = weibull_sweetpoints(UML["phi"][end,:])
    end

    est_alpha = UML["phi"][end, 1] #if scale is Logarithmic this needs to stay in log coordinates
    if UML["par"]["model"] == "logistic"
        xCeiling = invLogisticPsy(UML["par"]["lambdaSwptPC"]-UML["est_lapse"], est_alpha, UML["est_slope"], UML["gamma"], UML["est_lapse"])
    elseif UML["par"]["model"] == "gaussian"
        xCeiling = invGaussianPsy(UML["par"]["lambdaSwptPC"]-UML["est_lapse"], est_alpha, UML["est_slope"], UML["gamma"], UML["est_lapse"])
    elseif UML["par"]["model"] == "weibull"
        xCeiling = invWeibullPsy(UML["par"]["lambdaSwptPC"]-UML["est_lapse"], est_alpha, UML["est_slope"], UML["gamma"], UML["est_lapse"])
    end
   
    lmbdSwpt = min(max(UML["par"]["suggestedLambdaSwpt"], xCeiling), UML["par"]["x"]["limits"][2])
    
    push!(swpt, lmbdSwpt)

    UML["swpt"] = swpt
    swpt = max(min(swpt[UML["swpts_idx"]], UML["par"]["x"]["limits"][2]), UML["par"]["x"]["limits"][1])#; % limit the sweet points to be within the stimulus space

    if UML["par"]["swptRule"] == "up-down"
        push!(UML["rev_flag"], 0)
        if r >= 0.5
            if UML["step_flag"] == UML["par"]["nDown"]-1
                UML["current_step"] = max(UML["current_step"]-1,1)
                newx = swpt[UML["current_step"]]
                UML["step_flag"] = 0
                if UML["track_direction"] == 1
                    push!(UML["rev_flag"], 1)
                    UML["nrev"] = UML["nrev"] +1
                end
                UML["track_direction"] = -1
            elseif UML["step_flag"] < UML["par"]["nDown"]-1
                newx = swpt[UML["current_step"]]
                UML["step_flag"] = UML["step_flag"]+1
            end
        elseif r <= 0.5
            UML["current_step"] = min(UML["current_step"]+1, UML["nsteps"])
            newx = swpt[UML["current_step"]]
            UML["step_flag"] = 0
            if UML["track_direction"] == -1
                push!(UML["rev_flag"], 1)
                UML["nrev"] = UML["nrev"]+1
            end
            UML["track_direction"] = 1
        end
    elseif UML["par"]["swptRule"] == "random"
            newx = swpt[rand([1,2,3,4])]
    end

    if UML["n"] < 2
        UML["swpts"] = reshape(swpt, (1,4))
    else
        UML["swpts"] = hcat(UML["swpts"], reshape(swpt, (1,4)))
    end
    UML["xnext"] = newx

    if UML["par"]["stimScale"] == "logarithmic"
        UML["xnextLinear"] = exp(UML["xnext"])
    else
        UML["xnextLinear"] = UML["xnext"]
    end

    println(string("Est Midpoint: ", UML["est_midpoint"]))
    println(string("Est Slope: ", UML["est_slope"]))
    println(string("Est Lapse: ", UML["est_lapse"]))
    println(string("Next level: ", UML["xnextLinear"]))
    if UML["par"]["stimScale"] == "logarithmic"
        println(string("xCeiling: ", exp(xCeiling)))
        println(sytring("Lambda Swpt: ", exp(lmbdSwpt)))
    else
        println(string("xCeiling: ", xCeiling))
        println(string("Lambda Swpt: ", lmbdSwpt))
    end
        
    return UML
end

function logit_sweetpoints(phi, minAlpha, maxAlpha)

    function alphavar_est(x, alpha, beta, gamma, lambdax)

        term1 = exp(2*beta*(alpha-x))
        term2 = (1+exp(beta*(x-alpha))).^2
        term3 = -gamma+(lambdax-1)*exp(beta*(x-alpha))
        term4 = 1-gamma+lambdax*exp(beta*(x-alpha))
        term5 = beta.^2*(-1+gamma+lambdax).^2

        sigmaalphasq = -term1*term2*term3*term4/term5

        return sigmaalphasq
    end


    function betavar_est1(x, alpha, beta, gamma, lambdax)

        term1 = exp(2*beta*(alpha-x))
        term2 = (1+exp(beta*(x-alpha))).^2
        term3 = -gamma+(lambdax-1)*exp(beta*(x-alpha))
        term4 = 1-gamma+lambdax*exp(beta*(x-alpha))
        term5 = (x-alpha).^2*(-1+gamma+lambdax).^2

        sigmabetasq = (-term1*term2*term3*term4/term5) +(x>=alpha)*1e10

        return sigmabetasq
    end

    function betavar_est2(x, alpha, beta, gamma, lambdax)

        term1 = exp(2*beta*(alpha-x))
        term2 = (1+exp(beta*(x-alpha))).^2
        term3 = -gamma+(lambdax-1)*exp(beta*(x-alpha))
        term4 = 1-gamma+lambdax*exp(beta*(x-alpha))
        term5 = (x-alpha).^2*(-1+gamma+lambdax).^2

        sigmabetasq = (-term1*term2*term3*term4/term5) +(x<=alpha)*1e10

        return sigmabetasq
    end

    function wrap_alphavar_est(x)
        return alphavar_est(x, alpha, beta, gamma, lambdax)
    end

    function wrap_betavar_est1(x)
        return betavar_est1(x, alpha, beta, gamma, lambdax)
    end

    function wrap_betavar_est2(x)
        return betavar_est1(x, alpha, beta, gamma, lambdax)
    end

    alpha = phi[1]
    beta = phi[2]
    gamma = phi[3]
    lambdax = phi[4]

    swpts = zeros(3)

    swpts[1] = optimize(wrap_betavar_est1, minAlpha-10, maxAlpha-10).minimum
    swpts[3] = optimize(wrap_betavar_est2, minAlpha+10, maxAlpha+10).minimum
    swpts[2] = g = optimize(wrap_alphavar_est, minAlpha, maxAlpha).minimum #optimize(alphavar_est, [alpha])
    sort!(swpts)

    return swpts
end



# def weibull_sweetpoints(phi):

#     k = phi[0]
#     beta = phi[1]
#     gamma = phi[2]
#     lambdax = phi[3]

#     def kvar_est(x):

#         term1 = k.^2*(x/k).^(-2*beta)
#         term2 = -1+gamma-exp((x/k).^beta)*(-1+lambdax)+lambdax
#         term3 = -1+gamma+lambdax-exp((x/k).^beta)*lambdax
#         term4 = beta.^2*(-1+gamma+lambdax).^2

#         sigmaksq = -term1*term2*term3/term4
#         return sigmaksq

#     def betavar_est1(x):

#         term1 = (x/k).^(-2*beta)
#         term2 = -1+gamma-exp((x/k).^beta)*(-1+lambdax)+lambdax
#         term3 = -1+gamma+lambdax-exp((x/k).^beta)*lambdax
#         term4 = (-1+gamma+lambdax).^2*log(x/k).^2

#         sigmabetasq = -term1*term2*term3/term4 + (x>=k)*1e10
#         return sigmabetasq

#     def betavar_est2(x):

#         term1 = (x/k).^(-2*beta)
#         term2 = -1+gamma-exp((x/k).^beta)*(-1+lambdax)+lambdax
#         term3 = -1+gamma+lambdax-exp((x/k).^beta)*lambdax
#         term4 = (-1+gamma+lambdax).^2*log(x/k).^2

#         sigmabetasq = -term1*term2*term3/term4 + (x<=k)*1e10
#         return sigmabetasq

#     # swpts[0] = fminsearch(@(x) betavar_est(x,k,beta,gamma,lambdax)+(x>=k)*1e10,k/2,opt)
#     # swpts[2] = fminsearch(@(x) betavar_est(x,k,beta,gamma,lambdax)+(x<=k)*1e10,k*2,opt)
#     # swpts[1] = fminsearch(@(x) kvar_est(x,k,beta,gamma,lambdax),k,opt)
    
#     swpts = np.zeros(3)
#     swpts[0] = scipy.optimize.fmin(betavar_est1, x0=k/2)
#     swpts[2] = scipy.optimize.fmin(betavar_est2, x0=k*2)
#     swpts[1] = scipy.optimize.fmin(kvar_est, x0=k)
#     swpts = np.maximum(np.sort(swpts), 0)

#     return swpts

# def gaussian_sweetpoints(phi):
    
#     def psycfunc(x, phi):
#         mu = phi[0]
#         sigma = phi[1]
#         gamma = phi[2]
#         lambdax = phi[3]
#         p = gamma+((1-gamma-lambdax)/2)*(1+erf((x-mu)/sqrt(2*sigma.^2)))
#         return p

#     def psycfunc_derivative_mu(x, phi):
#         mu = phi[0]
#         sigma = phi[1]
#         gamma = phi[2]
#         lambdax = phi[3]
#         dpdm = -(1-gamma-lambdax)/(sqrt(2*pi)*sigma)*exp(-(x-mu).^2/(2*sigma.^2))
#         return dpdm

#     def psycfunc_derivative_sigma(x, phi):
#         mu = phi[0]
#         sigma = phi[1]
#         gamma = phi[2]
#         lambdax = phi[3]
#         dpds = -(1-gamma-lambdax)*(x-mu)/(sqrt(2*pi)*sigma.^2)*exp(-(x-mu).^2/(2*sigma.^2))
#         return dpds

#     #sigma2_mu = @(x) psycfunc(x,phi)*(1-psycfunc(x,phi))/ (psycfunc_derivative_mu(x,phi)).^2
    
#     #sigma2_sigma = @(x) psycfunc(x,phi)*(1-psycfunc(x,phi))/ (psycfunc_derivative_sigma(x,phi)).^2

#     def sigma2_mu(x):
#         out = psycfunc(x, phi)*(1-psycfunc(x, phi))/ (psycfunc_derivative_mu(x, phi)).^2
#         return out
#     def sigma2_sigma(x):
#         out = psycfunc(x, phi)*(1-psycfunc(x, phi))/ (psycfunc_derivative_sigma(x, phi)).^2
#         return out
    
#     # swpt_mu = fminsearch(sigma2_mu, phi(1))
#     # swpt_sigma_L = fminsearch(sigma2_sigma, phi(1)-10)
#     # swpt_sigma_H = fminsearch(sigma2_sigma, phi(1)+10)

#     swpt_mu = scipy.optimize.fmin(sigma2_mu, x0=phi[0])
#     swpt_sigma_L = scipy.optimize.fmin(sigma2_sigma, x0=phi[0]-10)
#     swpt_sigma_H = scipy.optimize.fmin(sigma2_sigma, x0=phi[0]+10)
#     swpts = np.array([swpt_sigma_L, swpt_mu, swpt_sigma_H])

#     return swpts
