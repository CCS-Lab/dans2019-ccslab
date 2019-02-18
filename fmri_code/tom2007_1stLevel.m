% tom2007_1stLevel.m
% First-level analysis of Tom et al (2007) Science data
% download and add "tsvread.m" from https://kr.mathworks.com/matlabcentral/fileexchange/32782-tsvread-importing-tab-separated-data?focused=a53e9d7b-eac4-4992-21fa-d380115d33e5&tab=function

clear all  % clear workspace

%% set ID, def_path
defThres = 0.2;   % default threshold
stimDuration = 0;   % stimulus duration (0 sec = delta function);
smoothing = [8 8 8];  % smoothing 
currApproach = ['tom2007_d' num2str(stimDuration)];  % current approach.. 

[data_path ID] = fileparts(pwd);  % e.g., ID = '576-D-1';
%data_path = '/mnt/nfs/proj/visuperc/wahn/data/';  % CHECK THIS PATH!!
def_path = fullfile(data_path, ID);

% reg_path - where regressor *.tsv files exist
reg_path = fullfile(def_path, 'func');

% data_path - where trial-by-trial data exist
data_path = '/Users/wahn/Dropbox/Research/DANS_2019/behav_data';

disp( ['ID = ' ID ] );
disp( ['Approach = ' currApproach] );
disp( ['pwd = ' pwd ])

%% gunzip all nii.gz files first
gunzip(fullfile(reg_path, '*.gz'))

disp('All functional image files are unzipped for SPM analysis')

%% Path containing data
% path for confounding factors
move_path_origin1 = fullfile(reg_path, [ID '_task-mixedgamblestask_run-01_bold_confounds.tsv'] ); 
move_path_origin2 = fullfile(reg_path, [ID '_task-mixedgamblestask_run-02_bold_confounds.tsv'] ); 
move_path_origin3 = fullfile(reg_path, [ID '_task-mixedgamblestask_run-03_bold_confounds.tsv'] ); 
disp('movement path defined')
%% create "R" variable from movement_regressor matrix and save
% run1
[data1, header1, ] = tsvread(move_path_origin1);
R = data1(2:end, (end-5):end);  % remove the first row, 26-31 columns --> movement regressors
save func/movement_regressors_for_epi_01.mat R 
move_path_run1 = fullfile(reg_path, 'movement_regressors_for_epi_01.mat');

% run2
[data2, header2, ] = tsvread(move_path_origin2);
R = data2(2:end, (end-5):end);  % remove the first row, 26-31 columns --> movement regressors
save func/movement_regressors_for_epi_02.mat R 
move_path_run2 = fullfile(reg_path, 'movement_regressors_for_epi_02.mat');

% run3
[data3, header3, ] = tsvread(move_path_origin3);
R = data3(2:end, (end-5):end);  % remove the first row, 26-31 columns --> movement regressors
save func/movement_regressors_for_epi_03.mat R 
move_path_run3 = fullfile(reg_path, 'movement_regressors_for_epi_03.mat');

%% Load regressors
% onset
% duration
% parametric loss
% distance from indifference
% parametric gain
% gain
% loss
% PTval
% respnum
% respcat: 1=accept, 0=reject
% response_time: RT

[run1, header_run1, ] = tsvread( fullfile(data_path, [ID, '_task-mixedgamblestask_run-01_events.tsv']));
[run2, header_run2, ] = tsvread( fullfile(data_path, [ID, '_task-mixedgamblestask_run-02_events.tsv']));
[run3, header_run3, ] = tsvread( fullfile(data_path, [ID, '_task-mixedgamblestask_run-03_events.tsv']));

%load( fullfile(reg_path, [ID '_IQ_run1.mat'] ) )
%load( fullfile(reg_path, [ID '_IQ_run2.mat'] ) )

disp('Runs 1-3 values loaded')


%% Initialise SPM defaults
spm('defaults', 'FMRI');
spm_jobman('initcfg'); % SPM8 only

%%
%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 4252 $)
%-----------------------------------------------------------------------

% create a directory where data will be saved
mkdir( fullfile( def_path, currApproach) )

% delete SPM.mat file if it exists already
if exist( fullfile( def_path, currApproach, 'SPM.mat') )
    fprintf('\n SPM.mat exists in this directory. Overwriting SPM.mat file! \n\n')
    delete( fullfile( def_path, currApproach, 'SPM.mat') )
end


%% smooth files first...

% run1
matlabbatch = [];  % clear matlabbatch..
epipath = fullfile(def_path, 'func');  % location of the preprocessed files
tmpFiles = dir(fullfile(epipath, 'sub-*run-01*preproc.nii'));   % find the file
% Here lines differ for 3D vs. 4D %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is for 4D multiple files
% get herder information to read a 4D file
tmpHdr = spm_vol( fullfile(epipath, tmpFiles.name) );
f_list_length = size(tmpHdr, 1);  % number of 3d volumes
for jx = 1:f_list_length
    scanFiles{jx,1} = [epipath '/' tmpFiles.name ',' num2str(jx) ] ; % add numbers in the end
    % End of difference for 3D vs. 4D %%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
matlabbatch{1}.spm.spatial.smooth.data = scanFiles;
matlabbatch{1}.spm.spatial.smooth.fwhm = smoothing;
matlabbatch{1}.spm.spatial.smooth.dtype = 0;
matlabbatch{1}.spm.spatial.smooth.im = 0;
matlabbatch{1}.spm.spatial.smooth.prefix = 's';
spm_jobman('run', matlabbatch) 
disp('run 1 smoothing is complete')

% run2
matlabbatch = [];  % clear matlabbatch..
epipath = fullfile(def_path, 'func');  % location of the preprocessed files
tmpFiles = dir(fullfile(epipath, 'sub-*run-02*preproc.nii'));   % find the file
% Here lines differ for 3D vs. 4D %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is for 4D multiple files
% get herder information to read a 4D file
tmpHdr = spm_vol( fullfile(epipath, tmpFiles.name) );
f_list_length = size(tmpHdr, 1);  % number of 3d volumes
for jx = 1:f_list_length
    scanFiles{jx,1} = [epipath '/' tmpFiles.name ',' num2str(jx) ] ; % add numbers in the end
    % End of difference for 3D vs. 4D %%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
matlabbatch{1}.spm.spatial.smooth.data = scanFiles;
matlabbatch{1}.spm.spatial.smooth.fwhm = smoothing;
matlabbatch{1}.spm.spatial.smooth.dtype = 0;
matlabbatch{1}.spm.spatial.smooth.im = 0;
matlabbatch{1}.spm.spatial.smooth.prefix = 's';
spm_jobman('run', matlabbatch) 
disp('run 2 smoothing is complete')

% run3
matlabbatch = [];  % clear matlabbatch..
epipath = fullfile(def_path, 'func');  % location of the preprocessed files
tmpFiles = dir(fullfile(epipath, 'sub-*run-03*preproc.nii'));   % find the file
% Here lines differ for 3D vs. 4D %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is for 4D multiple files
% get herder information to read a 4D file
tmpHdr = spm_vol( fullfile(epipath, tmpFiles.name) );
f_list_length = size(tmpHdr, 1);  % number of 3d volumes
for jx = 1:f_list_length
    scanFiles{jx,1} = [epipath '/' tmpFiles.name ',' num2str(jx) ] ; % add numbers in the end
    % End of difference for 3D vs. 4D %%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
matlabbatch{1}.spm.spatial.smooth.data = scanFiles;
matlabbatch{1}.spm.spatial.smooth.fwhm = smoothing;
matlabbatch{1}.spm.spatial.smooth.dtype = 0;
matlabbatch{1}.spm.spatial.smooth.im = 0;
matlabbatch{1}.spm.spatial.smooth.prefix = 's';
spm_jobman('run', matlabbatch) 
disp('run 3 smoothing is complete')

matlabbatch = [];  % clear matlabbatch..

%% run 1

matlabbatch{1}.spm.stats.fmri_spec.dir = { fullfile( def_path, currApproach) };
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;

% rescan files
tmpFiles = dir(fullfile(epipath, 'ssub*run-01*preproc.nii'));   % find the file
% Here lines differ for 3D vs. 4D %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is for 4D multiple files
% get herder information to read a 4D file
tmpHdr = spm_vol( fullfile(epipath, tmpFiles.name) );
f_list_length = size(tmpHdr, 1);  % number of 3d volumes
for jx = 1:f_list_length
    scanFiles{jx,1} = [epipath '/' tmpFiles.name ',' num2str(jx) ] ; % add numbers in the end
    % End of difference for 3D vs. 4D %%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans = scanFiles;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond.name = 'stimulus_onset';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond.onset =  run1(2:end, 1);

%%% parametric modulators
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond.duration = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond.tmod = 0;

% PM1: gain
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond.pmod(1).name = 'gain';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond.pmod(1).param = run1(2:end, 5); % parametric gain
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond.pmod(1).poly = 1;
% PM2: loss
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond.pmod(2).name = 'loss';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond.pmod(2).param = run1(2:end, 3); % parametric loss
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond.pmod(2).poly = 1;
% PM3: indifference 
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond.pmod(3).name = 'indifference';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond.pmod(3).param = run1(2:end, 4); % indifference point
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond.pmod(3).poly = 1;

% Remaining details...
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond.orth = 0;   % don't orthogonalize PM regressors
matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg = {move_path_run1};
matlabbatch{1}.spm.stats.fmri_spec.sess(1).hpf = 128;

%% run 2

epipath = fullfile(def_path, 'func');  % location of the preprocessed files
tmpFiles = dir(fullfile(epipath, 'ssub*run-02*preproc.nii'));   % find the file
% Here lines differ for 3D vs. 4D %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is for 4D multiple files
% get herder information to read a 4D file
tmpHdr = spm_vol( fullfile(epipath, tmpFiles.name) );
f_list_length = size(tmpHdr, 1);  % number of 3d volumes
for jx = 1:f_list_length
    scanFiles{jx,1} = [epipath '/' tmpFiles.name ',' num2str(jx) ] ; % add numbers in the end
    % End of difference for 3D vs. 4D %%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

matlabbatch{1}.spm.stats.fmri_spec.sess(2).scans = scanFiles;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond.name = 'stimulus_onset';
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond.onset =  run2(2:end, 1);

%%% parametric modulators
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond.duration = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond.tmod = 0;

% PM1: gain
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond.pmod(1).name = 'gain';
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond.pmod(1).param = run2(2:end, 5); % parametric gain
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond.pmod(1).poly = 1;
% PM2: loss
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond.pmod(2).name = 'loss';
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond.pmod(2).param = run2(2:end, 3); % parametric loss
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond.pmod(2).poly = 1;
% PM3: indifference 
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond.pmod(3).name = 'indifference';
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond.pmod(3).param = run2(2:end, 4); % indifference point
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond.pmod(3).poly = 1;

% Remaining details...
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond.orth = 0;   % don't orthogonalize PM regressors
matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess(2).regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi_reg = {move_path_run2};
matlabbatch{1}.spm.stats.fmri_spec.sess(2).hpf = 128;


%% run 3

epipath = fullfile(def_path, 'func');  % location of the preprocessed files
tmpFiles = dir(fullfile(epipath, 'ssub*run-03*preproc.nii'));   % find the file
% Here lines differ for 3D vs. 4D %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is for 4D multiple files
% get herder information to read a 4D file
tmpHdr = spm_vol( fullfile(epipath, tmpFiles.name) );
f_list_length = size(tmpHdr, 1);  % number of 3d volumes
for jx = 1:f_list_length
    scanFiles{jx,1} = [epipath '/' tmpFiles.name ',' num2str(jx) ] ; % add numbers in the end
    % End of difference for 3D vs. 4D %%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

matlabbatch{1}.spm.stats.fmri_spec.sess(3).scans = scanFiles;
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond.name = 'stimulus_onset';
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond.onset = run3(2:end, 1);

%%% parametric modulators
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond.duration = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond.tmod = 0;

% PM1: gain
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond.pmod(1).name = 'gain';
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond.pmod(1).param = run3(2:end, 5); % parametric gain
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond.pmod(1).poly = 1;
% PM2: loss
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond.pmod(2).name = 'loss';
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond.pmod(2).param = run3(2:end, 3); % parametric loss
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond.pmod(2).poly = 1;
% PM3: indifference 
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond.pmod(3).name = 'indifference';
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond.pmod(3).param = run3(2:end, 4); % indifference point
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond.pmod(3).poly = 1;

% Remaining details...
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond.orth = 0;   % don't orthogonalize PM regressors
matlabbatch{1}.spm.stats.fmri_spec.sess(3).multi = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess(3).regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(3).multi_reg = {move_path_run3};
matlabbatch{1}.spm.stats.fmri_spec.sess(3).hpf = 128;


%% These are for all 3 runs

matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.2;   % threshold
matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

%% run categorical model specification
spm_jobman('run', matlabbatch) 
disp('categorical model is specified')

%% categorical model estimation
matlabbatch = [];
matlabbatch{1}.spm.stats.fmri_est.spmmat = { fullfile(def_path, currApproach, 'SPM.mat') };
matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
spm_jobman('run', matlabbatch) 
disp('categorical model is estimated')

%% create contrasts 
% parametric modulation of gain & loss
% DON'T FORGET MOVEMENT REGRESSORS!! 

matlabbatch = [];
matlabbatch{1}.spm.stats.con.spmmat = { fullfile(def_path, currApproach, 'SPM.mat') };

matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'gain_PM';  % 
matlabbatch{1}.spm.stats.con.consess{1}.tcon.convec = [0 1/3 0 0  0 0 0 0 0 0  0 1/3 0 0  0 0 0 0 0 0  0 1/3];
matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';

matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'loss_PM';  % 
matlabbatch{1}.spm.stats.con.consess{2}.tcon.convec = [0 0 1/3 0  0 0 0 0 0 0  0 0 1/3 0  0 0 0 0 0 0  0 0 1/3];
matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';

matlabbatch{1}.spm.stats.con.delete = 0;

spm_jobman('run', matlabbatch) 
disp([currApproach ' model: contrasts are generated'])



