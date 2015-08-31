function [retain_trials]=axcorr_btlfp_plot(WIN,WIN_ID,WIN_T,NBOOT,FACECOLOR,EDGECOLOR)
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

[uniq_win,~,win_idx]=unique(WIN_ID);
nwin=length(uniq_win);
win_idx_count=zeros(1,nwin);

for i=1:nwin
	win_idx_count(i)=sum(win_idx==i);
end

% retain this many trials from each cell

min_trials=min(win_idx_count);
retain_trials=[];

for i=1:nwin
	tmp=find(win_idx==i);
	idx=1:length(tmp);
	retain_trials=[retain_trials;tmp(idx<=min_trials)];
end

% new wins

hil_win=WIN(:,retain_trials);
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
