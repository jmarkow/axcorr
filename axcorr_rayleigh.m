function [R,Z,PVAL]=sfa_rayleigh_stats(PLI,N)
%
%
%
%
%

R=PLI.*N;
Z=(R.^2)./N;
PVAL=exp(sqrt(1+4*N+4.*(N^2-R.^2))-(1+2*N));


