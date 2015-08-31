function axcorr_fig1b
%
%
%


[options,dirs]=axcorr_preflight;

% get  

load(fullfile(dirs.save_dir,'btlfp_data.mat'),'BTLFP');
fig=axcorr_plot_btlfp(BTLFP);
set(fig,'units','centimeters','position',[3 3 7.5 6.5],'paperpositionmode','auto');
markolab_multi_fig_save(fig,dirs.save_dir,'btlfp_meanandpli','eps,png,fig,pdf');
