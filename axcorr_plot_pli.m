function axcorr_plot_pli(WIN,WIN_T,NBOOT,FACECOLOR,EDGECOLOR)
%
%
%
%
%
%


% function for converting to Rayleigh Z
% convert to Rayleigh Z or some unbiased estimator

% convert hil windows to PLI, then convert to unbiased PLI estimator w/ CIs

% first get cell ids, grab same number of cell ids

hil_win=WIN;
n=size(hil_win,2)
pli=abs(mean(hil_win,2));
pli_r=pli*n;
pli_z=(pli_r.^2)/n;
bootfun=@(x) ((abs(mean(x))*n).^2)/n;

% confidence interval

ci=bootci(NBOOT,{bootfun,hil_win'},'type','cper');

markolab_shadeplot(WIN_T,ci,FACECOLOR,EDGECOLOR);
hold on;
plot(WIN_T,pli_z,'b-','color',EDGECOLOR);
