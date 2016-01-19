function [ave_mat,peak_times,peak_vals]=axcorr_cadata_sortmat(DATA,varargin)
% takes data from stan_format_cadata and generates a series of panels for each time point
%
%
%
%
%
%

movie_fs=22; % sampling rate of camera
sort_day=1; % day to use for sorting
peak_check=0; % check for peak consistency
peak_thresh=.05; % if closest peak is >peak_thresh, exclude roi
dff_check=.5; % check for dff peak
chk_day=1; % check for dff peak day
scaling='r'; % scaling ('r' for within roi across days, 's' for within roi sort day, 'l' for within roi and day)
smoothing=0; % smooth ca trace (not working yet)
smooth_kernel='g'; % gauss smoothing kernel (b for boxcar)
padding=[1 1]; % padding before and after song
realign=0;

nparams=length(varargin);

if mod(nparams,2)>0
	error('Parameters must be specified as parameter/value pairs');
end

for i=1:2:nparams
	switch lower(varargin{i})
		case 'movie_fs'
			movie_fs=varargin{i+1};
		case 'upsample'
			upsample=varargin{i+1};
		case 'sort_day'
			sort_day=varargin{i+1};
		case 'peak_check'
			peak_check=varargin{i+1};
		case 'peak_thresh'
			peak_thresh=varargin{i+1};
		case 'dff_check'
			dff_check=varargin{i+1};
		case 'scaling'
			scaling=varargin{i+1};
		case 'smoothing'
			smoothing=varargin{i+1};
		case 'smooth_kernel'
			smooth_kernel=varargin{i+1};
		case 'fig_row'
			fig_row=varargin{i+1};
		case 'fig_nrows'
			fig_nrows=varargin{i+1};
		case 'chk_day'
			chk_day=varargin{i+1};
		case 'bin_fluo'
			bin_fluo=varargin{i+1};
		case 'nbins'
			nbins=varargin{i+1};
    case 'padding'
			padding=varargin{i+1};
		case 'realign'
			realign=varargin{i+1};
	end
end

% take sort day, clean up according to criteria (consistent peak? high ave?)

if ~iscell(DATA)
	tmp{1}=DATA;
	DATA=tmp;
end

ndays=length(DATA);
[nsamples,nrois,ntrials]=size(DATA{1});

[DATA,phase_shift,inc_rois]=axcorr_cadata_preprocess(DATA,'peak_check',peak_check,'peak_thresh',peak_thresh,'movie_fs',movie_fs,...
	'smoothing',smoothing,'smooth_kernel',smooth_kernel,'padding',padding,'realign',realign,'chk_day',chk_day);

ave_mat=mean(DATA{1},3);

% collect peaks from the average data

[nsamples,nrois]=size(ave_mat);
[peak_times peak_vals]=fb_compute_peak_simple(ave_mat,...
	'thresh_t',.2,'debug',0,'onset_only',0,'thresh_hi',.5,'thresh_int',8,'thresh_dist',.2,...
	'fs',movie_fs); % thresh_int previously 5

% remove peak times outside of pads...

pad_smps=round(padding*(movie_fs));
