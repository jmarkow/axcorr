function fig=axcorr_btlfp_plot(BTLFP)
%
%
%
%
%
%

[options,dirs]=axcorr_preflight;

% function for converting to Rayleigh Z
% convert to Rayleigh Z or some unbiased estimator

% convert hil windows to PLI, then convert to unbiased PLI estimator w/ CIs

% first get cell ids, grab same number of cell ids

nbootstraps=options.pli_bootstraps;

win=BTLFP.int.hil_win;
win_id=BTLFP.int.cell_id;

nsamples=size(BTLFP.int.hil_win,1);
xwin=floor(nsamples/2);
win_t=[-xwin:xwin]/options.lfp_fs;
win_t=win_t*1e3;

% window center

% 2 x 2 grid, mean waveform on top, aligned PLI below

fig=figure();

ax(3)=subplot(2,2,3);
[inc_trials]=axcorr_plot_pli(win,win_id,win_t,nbootstraps,[0 0 1],[0 0 0]);
ylimits=ylim();
plot([0 0],[ylimits],'k--');
set(gca,'YTick',ylimits,'Ylimmode','manual','FontSize',8);
yh=ylabel('PLI (Z)');
set(yh,'position',get(yh,'position')+[-.2 0 0]);
box on;

ax(1)=subplot(2,2,1);

mu=mean(BTLFP.int.lfp_win(:,inc_trials),2);
lim=max(abs(mu));
lim_rnd=ceil(lim*10)/10;

plot(win_t,mu,'b-');
ylim([-lim_rnd lim_rnd]);
ylimits=ylim();
hold on;

plot([0 0],[ylimits],'k--');
yh=ylabel('Amp. (Z)');
set(gca,'YTick',ylimits,'xtick',[],'FontSize',8);
set(yh,'position',get(yh,'position')+[-.2 0 0]);

peakmask=BTLFP.pn.peakcount>1; % pn
win=BTLFP.pn.hil_win(:,peakmask);
win_id=BTLFP.pn.cell_id(peakmask);

ax(4)=subplot(2,2,4);
[inc_trials]=axcorr_plot_pli(win,win_id,win_t,nbootstraps,[1 0 0],[0 0 0]);
ylimits=ylim();
plot([0 0],[ylimits],'k--');
set(gca,'YTick',ylimits,'Ylimmode','manual','FontSize',8);
box on;
xlabel('Time (ms)');

ax(2)=subplot(2,2,2);
peak_idx=find(peakmask);
mu=mean(BTLFP.pn.lfp_win(:,peak_idx(inc_trials)),2);
lim=max(abs(mu));
lim_rnd=ceil(lim*10)/10;

plot(win_t,mu,'r-');
ylim([-lim_rnd lim_rnd]);
ylimits=ylim();
hold on;
plot([0 0],[ylimits],'k--');
set(gca,'YTick',ylimits,'xtick',[],'FontSize',8);

linkaxes(ax,'x');
