function axcorr_fig2
%
%
%


[options,dirs]=axcorr_preflight;

% get  

load(fullfile(dirs.save_dir,'gestlfp_data.mat'),'lfp');
fig=axcorr_plot_gestlfp(lfp);
set(fig,'units','centimeters','position',[3 3 7.5 6.5],'paperpositionmode','auto');
markolab_multi_fig_save(fig,dirs.save_dir,'gestlfp_meanandpli','eps,png,fig,pdf');
