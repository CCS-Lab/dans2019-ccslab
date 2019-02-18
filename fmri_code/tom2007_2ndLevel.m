% tom2007_2ndLevel.m
% Second-level analysis of Tom et al (2007) Science data

clear all; clc;
tom_var = 'stimulus_onset';
%covars = {'age', 'male'};
covars = {};

allConds = {'gain', 'loss'};

method = 'tom2007_d0'; % method of analysis
data_path = '/Users/wahn/Dropbox/Research/DANS_2019/fmri_pilot/'; % data (1st level SPM.mat) path. DO NOT PUT '/' IN THE END!
output_path = fullfile('/Users/wahn/Dropbox/Research/DANS_2019/', method);  % output path

subjIDs_name = {'sub-01', 'sub-02'};

numSubjs = length(subjIDs_name);  % this will be replaced with newly selected subjects...


%% Initialise SPM defaults
spm('Defaults','fMRI');
spm_jobman('initcfg'); % SPM8 only

%%
for i = 1:length(allConds)
    
    cond = allConds{i};  
    
    % contrast number
    switch cond
        case 'gain'
            contrast_num = '0001';
        case 'loss'
            contrast_num = '0002';
    end
    dir_name = cond;
    
    %% specification
    matlabbatch = [];
    mkdir( fullfile(output_path, [dir_name '_N' num2str(numSubjs)]) )
    scanFiles = strcat(data_path, subjIDs_name' ,'/', method, '/con_', contrast_num, '.nii,1' );  % if using subjIDs_name
    
    matlabbatch{1}.spm.stats.factorial_design.dir = { fullfile(output_path, [dir_name '_N' num2str(numSubjs)]) };
    matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = scanFiles;
    matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
    matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
    matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
    matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
    matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
    matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
    matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
    matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
    
    if exist(fullfile(output_path, [dir_name '_N' num2str(numSubjs)], 'SPM.mat'))
        fprintf('\n SPM.mat exists in this directory. Overwriting SPM.mat file! \n\n')
        delete(fullfile(output_path, [dir_name '_N' num2str(numSubjs)], 'SPM.mat'))
    end
    
    spm_jobman('run', matlabbatch)
    disp(['2nd Level ' method ' model is specified']);
   
    %% estimation
    matlabbatch = [];
    matlabbatch{1}.spm.stats.fmri_est.spmmat = { fullfile(output_path, [dir_name '_N' num2str(numSubjs)], 'SPM.mat') };
    matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
    spm_jobman('run', matlabbatch)
    
    %% T-contrast (one-step t-test)
    matlabbatch = [];
    matlabbatch{1}.spm.stats.con.spmmat = { fullfile(output_path, [dir_name '_N' num2str(numSubjs)], 'SPM.mat') };
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = [dir_name '_N' num2str(numSubjs)];
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.convec = 1;
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    matlabbatch{1}.spm.stats.con.delete = 1;
    spm_jobman('run', matlabbatch)
    
    disp( [[dir_name '_N' num2str(numSubjs)] ' contrast is created'])
    disp( ['All done: ' method ', ' cond] )
    
end

% end of code

