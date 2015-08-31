function [BTLFP]=axcorr_btlfp_getdata
%
%
%
%
%
%

[options,dirs]=axcorr_preflight;

% get BTLFP for each cell type, map to struct, save to appropriate directory

cd(fullfile(dirs.root_dir,dirs.mu_dir));
[BTLFP.int.lfp_win,BTLFP.int.hil_win,BTLFP.int.peakcount,BTLFP.int.cell_id]=sfield_spiketriggerlfp_peak(options.lfp_filt_type);

cd(fullfile(dirs.root_dir,dirs.pn_dir));
[BTLFP.pn.lfp_win,BTLFP.pn.hil_win,BTLFP.pn.peakcount,BTLFP.pn.cell_id]=sfield_spiketriggerlfp_peak(options.lfp_filt_type);

save(fullfile(dirs.save_dir,'btlfp_data.mat'),'BTLFP');
