function fig=axcorr_plot_gestlfp(GEST_LFP)
%
%
%
%

[options,dirs]=axcorr_preflight;

% bootstrap waveform and pli, plot in separate panels, etc. etc.

% make plots, etc. etc.

inc_trials=axcorr_retain_trials(GEST_LFP.peak_id);

lfp_win=GEST_LFP.win(:,inc_trials);
lfp_hil=GEST_LFP.pli(:,inc_trials);
[nsamples,ntrials]=size(lfp_win);
xwin=floor(nsamples/2);

win_vec=[-xwin:xwin];
win_t=(win_vec/options.lfp_fs)*1e3;

% plot both with confidence intervals...

mu=mean(lfp_win');
ci=bootci(options.pli_bootstraps,{@mean,lfp_win'},'type','per');

size(mu)
size(ci)

fig=figure();
ax(1)=subplot(2,1,1);
markolab_shadeplot(win_t,ci,[0 0 1],[0 0 0]);
hold on;
plot(win_t,mu,'k-');
ylimits=ylim();
ylimits=[-max(abs(ylimits)) max(abs(ylimits))];
ylim([ylimits]);
plot([0 0],ylim(),'k--');
set(gca,'YLimMode','manual','TickDir','out','TickLength',[0 0],'YTick',[ylimits(1) ylimits(2)],'XTick',[],'FontSize',8);
yh=ylabel('Amp. (Z)');
set(yh,'position',get(yh,'position')+[-.2 0 0]);

%%%% pli

ax(2)=subplot(2,1,2);
axcorr_plot_pli(lfp_hil,win_t,options.pli_bootstraps,[0 0 1],[0 0 0]);
hold on;
plot([0 0],ylim(),'k--');
set(gca,'YLimMode','manual','TickDir','out','TickLength',[0 0],'YTick',ylim(),'XTick',win_t(1):100:win_t(end),'FontSize',8);
linkaxes(ax,'x');
xlabel('Time (ms)');
yh=ylabel('PLI (Z)');
set(yh,'position',get(yh,'position')+[-.2 0 0]);

