function [fr_win,peakcount,cell_id]=axcorr_get_gestpn();

% short script to estimate the coherence between spikes and LFPs collapsed across time
%
% methodology;
%
% 1) Compute multi-taper coherence
% 2) Compute either asymptotic or jackknife significance (jackknife will be much more time-consuming,
%    worth doing to validate distributional assumptions)

%[status,result]=unix(['find ' FIELD_DIR ' -type f -name "envelope_analog.mat"']);

[status,result]=unix(['find ' pwd ' -type f -name "spikedata_ch*.mat"']);
%[status,result]=unix(['find ' pwd ' -type f -name "gestdata.mat"']);
pkfile=regexp(result,'\n','split');

% coherence parameters

proc_fs=1e3; % processing frequency

bound=[.001];
% signals must be organized in a trial x sample matrix (matching trials and samples)

win=.1; % in s
proc_fs=5000;
nrands=1e3;
max_wins=1e4;
ifr_cutoff=80;
% samples on each side of zero

prespikes=[];
postspikes=[];
peakcount=[];
meanwave=[];
syllablecount=[];
win_samples=ceil(win.*proc_fs);
win_samples_vec=-win_samples:win_samples;

%lfp_win=zeros(length(win_samples_vec),max_wins);
cell_id=[];
peak_id=[];
counter=1;
wincounter=1;

bound=.1;

for i=1:length(pkfile)-1

	pkfile{i}
	[path,file,ext]=fileparts(pkfile{i});

	tokens=regexp(path,filesep,'split');
	birdid=tokens{end-3};

	load(fullfile(path,'envelope_analog.mat'),'gest_boundary','boundaryid','t');
	load(fullfile(path,'sta','fr_peaksandtroughs.mat'),'peaks','smoothrate','troughs','proc_fs');

	spike_fs=proc_fs;
	fid=fopen(fullfile(path,'cellinfo.txt'),'r');

	readdata=textscan(fid,'%s%[^\n]','commentstyle','#',...
		'delimiter','\t','MultipleDelimsAsOne',1);

	% close the file

	fclose(fid);

	% read in cluster number from cellinfo.txt

	clusternum=str2num(readdata{2}{find(strcmpi(readdata{1},'cluster:'))});
	channel=str2num(readdata{2}{find(strcmpi(readdata{1},'channel:'))});

	%proc_fs=1000;
	%filtlfp=downsample(filtlfp,2);

	if i==1
		thresh=80;
	else
		thresh=100;
	end

	tmppeaks=length(peaks)
	%tmppeaks=length(peaks);
	samples=length(smoothrate);
	points=gest_boundary;
	%points(points<win+.001|points>(samples/proc_fs-win-.001))=[];
	points=round(points.*proc_fs);
	points(points<win_samples|points>samples-win_samples)=[];

	issyllable=zeros(1,samples);

	timevec=[1:samples]./proc_fs;

	for j=1:samples
		[val,loc]=min(abs(timevec(j)-boundaryid(:,1)));

		if val<.005
			issyllable(j)=1;
		else
			issyllable(j)=0;
		end
	end

	% add random shift

	%insyllablepoints=find(issyllable);

	% for randomization

	%points=randsample(insyllablepoints,length(points))

	% do we want to load in the full matrix of spike counts?

	smoothrate=zscore(smoothrate);

	for j=1:length(points)

		tmp=smoothrate(points(j)-win_samples:points(j)+win_samples);
		tmp=tmp(:);
		fr_win(:,wincounter)=tmp;
		%fr_win(:,wincounter:(wincounter+size(tmp,2)-1))=tmp;

		%wincounter=wincounter+size(tmp,2);
		wincounter=wincounter+1;
		peak_id=[peak_id ones(1,size(tmp,2)).*counter];
		cell_id=[cell_id ones(1,size(tmp,2)).*i];
		peakcount=[peakcount ones(1,size(tmp,2)).*tmppeaks];
		%syllablecount(counter)=issyllable(points(j));
		counter=counter+1;
	end

end

fr_win(:,wincounter:end)=[];
