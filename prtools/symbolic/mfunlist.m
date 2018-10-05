function mfunlist
%MFUNLIST Special functions for MFUN.
%   MFUNLIST will be removed in a future release. 
%   Instead, use the appropriate special function listed below.
%   For example, use bernoulli(n) instead of mfun('bernoulli',n).
%
%   The following special functions are listed in alphabetical order
%   according to the third column. n denotes an integer argument, 
%   x denotes a real argument, and z denotes a complex argument. For 
%   more detailed descriptions of the functions, including any argument
%   restrictions, see the documentation of the active symbolic engine.
%
%bernoulli      n       Bernoulli Numbers                                     => bernoulli(n)
%bernoulli      n,z     Bernoulli Polynomials                                 => bernoulli(n,z)
%BesselI        x1,x    Bessel Function of the First Kind                     => besseli(v,x)
%BesselJ        x1,x    Bessel Function of the First Kind                     => besselj(v,x)
%BesselK        x1,x    Bessel Function of the Second Kind                    => besselk(v,x)
%BesselY        x1,x    Bessel Function of the Second Kind                    => bessely(v,x)
%Beta           z1,z2   Beta Function                                         => beta(x,y)
%binomial       x1,x2   Binomial Coefficients                                 => nchoosek(m,n)
%EllipticF -    z,k     Incomplete Elliptic Integral, First Kind              => ellipticF(z,k)
%EllipticK -    k       Complete Elliptic Integral, First Kind                => ellipticK(k)
%EllipticCK -   k       Complementary Complete Integral, First Kind           => ellipticCK(k)
%EllipticE -    k       Complete Elliptic Integrals, Second Kind              => ellipticE(k)
%EllipticE -    z,k     Incomplete Elliptic Integrals, Second Kind            => ellipticE(z,k)
%EllipticCE -   k       Complementary Complete Elliptic Integral, Second Kind => ellipticCE(k)
%EllipticPi -   nu,k    Complete Elliptic Integrals, Third Kind               => ellipticPi(nu,k)
%EllipticPi -   z,nu,k  Incomplete Elliptic Integrals, Third Kind             => ellipticPi(z,nu,k)
%EllipticCPi -  nu,k    Complementary Complete Elliptic Integral, Third Kind  => ellipticCPi(nu,k)
%erfc           z       Complementary Error Function                          => erfc(z)
%erfc           n,z     Complementary Error Function's Iterated Integrals     => erfc(n,z)
%Ci             z       Cosine Integral                                       => sinint(z)
%dawson         x       Dawson's Integral                                     => dawson(z)
%Psi            z       Digamma Function                                      => psi(z)
%dilog          x       Dilogarithm Integral                                  => dilog(x)
%erf            z       Error Function                                        => erf(z)
%euler          n       Euler Numbers                                         => euler(n)
%euler          n,z     Euler Polynomials                                     => euler(n,z)
%Ei             x       Exponential Integral                                  => ei(n)
%Ei             n,z     Exponential Integral                                  => expint(n,z)
%FresnelC       x       Fresnel Cosine Integral                               => fresnelc(x)
%FresnelS       x       Fresnel Sine Integral                                 => fresnels(x)
%GAMMA          z       Gamma Function                                        => gamma(z)
%harmonic       n       Harmonic Function                                     => harmonic(n)
%Chi            z       Hyperbolic Cosine Integral                            => coshint(z)
%Shi            z       Hyperbolic Sine Integral                              => sinhint(z)
%GAMMA          z1,z2   Incomplete Gamma Function                             => igamma(z1,z2)
%L              n,x     Laguerre                                              => laguerreL(n,x)
%L              n,x1,x  Generalized Laguerre                                  => laguerreL(n,x1,x)
%W              z       Lambert's W Function                                  => lambertw(z)
%W              n,z     Lambert's W Function                                  => lambertw(n,z)
%lnGAMMA        z       Logarithm of the Gamma function                       => gammaln(z)
%Li             x       Logarithmic Integral                                  => logint(x)
%Psi            n,z     Polygamma Function                                    => psi(n,z)
%Ssi            z       Shifted Sine Integral                                 => ssinint(z)
%Si             z       Sine Integral                                         => sinint(z)
%Zeta           z       (Riemann) Zeta Function                               => zeta(z)
%Zeta           n,z     (Riemann) Zeta Function                               => zeta(n,z)
%
%       Orthogonal Polynomials
%T      n,x             Chebyshev of the First Kind                           => chebyshevT(n,x)
%U      n,x             Chebyshev of the Second Kind                          => chebyshevU(n,x)
%G      n,x1,x          Gegenbauer                                            => gegenbauerC(n,x1,x)
%H      n,x             Hermite                                               => hermiteH(n,x)
%P      n,x1,x2,x       Jacobi                                                => jacobiP(n,x1,x2,x)
%P      n,x             Legendre                                              => legendreP(n,x)
%
%   See also MFUN, SYMENGINE.

%   Copyright 1993-2015 The MathWorks, Inc. 

warning(message('symbolic:mfun:FunctionToBeRemoved'));

help mfunlist
