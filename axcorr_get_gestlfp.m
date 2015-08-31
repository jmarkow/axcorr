function [BTLFP]=axcorr_btlfp_getdata
%
%
%
%
%
%

[options,dirs]=axcorr_preflight;

% get BTLFP for each cell type, map to struct, save to appropriate directory

cd(fullfile(dirs.gest_dir));

% run envelope correlation

aca_get_boundaries_envelope;

cd(fullfile(dirs.root_dir,dirs.lfp_dir))
spikefield_analysis_organizedata_envelope_analog;

[lfp.win,lfp.pli,lfp.peak_id,lfp.cell_id]=sfield_global_pli;
save(fullfile(dirs.save_dir,'gestlfp_data.mat'),'lfp','-v7.3');
