function [PEAKS,WINGRAB]=axcorr_cadata_corr(PEAKS,CONTRAST,BOUNDARY,varargin)
%
%
%
%

movie_fs=100; % sampling rate of camera
padding=[1 1]; % pads (for peak adjustment)
correction=1;
window=[.1 .1]; % window to grab contrast measure
peak_check=1; % check if peaks are in syllables or gaps?
syll_ave_thresh=.4;
gap_pad=0.005;

nparams=length(varargin);

if mod(nparams,2)>0
	error('Parameters must be specified as parameter/value pairs');
end

for i=1:2:nparams
	switch lower(varargin{i})
    case 'movie_fs'
      movie_fs=varargin{i+1};
    case 'padding'
      padding=varargin{i+1};
    case 'window'
      window=varargin{i+1};
		case 'peak_check'
			peak_check=varargin{i+1};
		case 'syll_ave_thresh'
			syll_ave_thresh=varargin{i+1};
	end
end

% read in peaks, a cell array in samples of movie frame rate, delete empties

idxs_to_del=cellfun(@isempty,PEAKS);
PEAKS(idxs_to_del)=[];

% remaining peaks

to_del=[];
for i=1:length(PEAKS)
	PEAKS{i}=PEAKS{i}./movie_fs+correction;
	if PEAKS{i}<padding(1) | PEAKS{i}>BOUNDARY.t(end)-padding(2)
		to_del=[to_del i];
	end
end

PEAKS(to_del)=[];

% peaks should now be in same units as boundaries and contrast

syllable_ave=mean(BOUNDARY.mat,2)>syll_ave_thresh;
syllable_col=BOUNDARY.t(markolab_collate_idxs(syllable_ave,0))
nsyllables=size(syllable_col,1);
% remove peaks in gaps

PEAKS=cat(2,PEAKS{:});
syllable_col=syllable_col+repmat([-gap_pad gap_pad],[size(syllable_col,1) 1]);

if peak_check
	to_del=[];
	for i=1:length(PEAKS)
		for j=1:nsyllables
			if PEAKS(i)>syllable_col(j,1) && PEAKS(i)<syllable_col(j,2)
				break;
			end
			if j==nsyllables
				to_del=[to_del i];
			end
		end
	end
	PEAKS(to_del)=[];
end

pool=[];
for i=1:size(syllable_col,1)
	pool=[pool syllable_col(i,1):.001:syllable_col(i,2)];
end

% determine significance with a Monte Carlo procedure, drawing from syllables

pool(pool<padding(1))=[];
pool(pool>BOUNDARY.t(end)-padding(2))=[];

% repeat at least 1e3 times

PEAKS=randsample(pool,length(PEAKS),true)

WINGRAB=[];
contrast_mu=mean(abs(CONTRAST.mat),2);
for i=1:length(PEAKS)
	[~,loc]=min(abs(CONTRAST.t-PEAKS(i)));
	WINGRAB=[WINGRAB contrast_mu(loc-5e3:loc+5e3)];
end

% get random points, 1e3 repetitions
