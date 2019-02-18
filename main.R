# (1) combine *.tsv files into a single txt file (tom2017_behav.txt) for computational modeling
# (2) run ra_noRA model with the tom2017_behav.txt file. 
# Programmed by Woo-Young Ahn
# Feb 2019
# Student version

rm(list = ls())  # clear workspace

# Install hBayesDM if it's not installed.
# Install the version in the develop branch on the GitHub repository.
if (!require(hBayesDM)) {
  install.packages('devtools')
  devtools::install_github('CCS-Lab/hBayesDM', ref = 'develop')
}
library(hBayesDM)  # load hBayesDM. hBayesDM should be installed first. 

# Install aws.s3 to download OpenNeuro data from AWS S3.
if (!require(aws.s3)) {
  install.packages('aws.s3')
}
library(aws.s3)

# Modify these two lines based on your settings 
################################################################################################
setwd("~/Dropbox/Research/DANS_2019/behav_code/")  # set working directory to ...
behav_data_path = "~/Dropbox/Research/DANS_2019/behav_data"  # path to behavioral data
################################################################################################

# make a list of files in behav_data_path
file_list = dir(behav_data_path)

all_data = NULL 
# read each file and combine them into a single file
for (i in 1:length(file_list)) {
  # read i_th data file
  tmpData = read.table(file.path(behav_data_path, file_list[i]), header=T, sep="\t")
  
  # find its subject ID 
  # From its file list, subject ID can be located as 5th~6th chracterer. Then convert it into an integer
  tmp_subjID = as.integer(substr(file_list[i], 5, 6))
  
  # add subject ID to tmpData 
  tmpData$subjID = tmp_subjID
  
  all_data = rbind(all_data, tmpData)  
}

# add 'cert' (certain outcome if subj don't gamble) column
all_data$cert = 0

# remove 'no response' trials (respcat == -1)
all_data = subset(all_data, respcat >= 0)  # select trials only if 'respcat' >= 0

# Copy 'respcat' to 'gamble' for hBayesDM. See ?hBayesDM::ra_noRA
all_data$gamble = all_data$respcat  # gamble=1 --> choose gamble, gamble=0 --> don't choose gamble

# check all_data
dim(all_data)  # it should be 3942x14
table(all_data$subjID)  # each subject should have 174-256 trials

# This is the notation of original data (subj-*_task-*_run-**_events.tsv files)
# Columns
#   - gain = potential gain (50% chance) when accepting a gamble
#   - loss = potential loss (50% chance) when accepting a gamble
#   - respnum
#     1 = strongly accept (gamble)
#     2 = weakly accept 
#     3 = weakly reject
#     4 = strongly reject
#   - respcat
#     1 = accept (gamble)
#     0 = reject 
#     -1 = no response

# save all_data as a text file so that it can be loaded from hBayesDM
write.table(all_data, "tom2017_behav.txt", col.names = T, row.names = F, sep = "\t")

# run ra_noRA (type ?ra_noRA for more info)
output1 = ra_noRA("tom2017_behav.txt", niter=1000, nwarmup=500, nchain=4, ncore=4, inits="fixed")
# check if rhat is less than 1.1
rhat(output1, less = 1.1)
# plot group parameters
plot(output1)
# plot individual parameters
plotInd(output1, "lambda")  # lambda (loss aversion)
plotInd(output1, "tau")  # tau (inverse temperature)
