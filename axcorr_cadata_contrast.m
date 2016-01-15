function [CONTRAST,BOUNDARY]=axcorr_cadata_contrast(AUDIO)
%
%
%
%

[options,dirs]=axcorr_preflight;
boundary_fs=1e3;
% get cadata, collect peak times and compare to envelope (or trigger cadata off of envelope peaks)

[nsamples,ntrials]=size(AUDIO.data);

CONTRAST.fs=AUDIO.fs;
CONTRAST.t=[1:size(AUDIO.data,1)]'./AUDIO.fs;

tmp1=zeros(size(AUDIO.data));
tmp2=zeros(size(AUDIO.data));

down_fact=round(AUDIO.fs/boundary_fs);
boundary_length=floor(nsamples/down_fact);

tmp3=zeros(boundary_length,ntrials);

parfor i=1:ntrials
  fprintf('Trial %i of %i\n',i,ntrials);
  [tmp1(:,i),tmp2(:,i)]=acontrast_envelope(AUDIO.data(:,i),AUDIO.fs,'use_band',[1e3 8e3]);
  [tmp3(:,i)]=zftftb_song_det(AUDIO.data(:,i),AUDIO.fs,'ratio_thresh',3,'song_duration',.015,'len',.001,'song_band',[2e3 8e3]);
end

CONTRAST.mat=tmp1;
CONTRAST.env=tmp2;

BOUNDARY.mat=tmp3;
BOUNDARY.t=cumsum([ 1/(boundary_fs*2);ones(size(tmp3,1)-1,1)*(1/boundary_fs) ]);
