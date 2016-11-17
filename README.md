# ProgrammingAssignment3

This repository contains an analysis of smartphone sensor data derived from [1]. It has been tidied up to meet the criteria outlined in [2].

The contents of this repository are:  
* README.md: this file  
* run_analysis.R: R script for running the analysis  
* result.txt: result of the analysis  
* codebook.md: description of the variables in result.txt  

Per the instructions provided for this project, run_analysis.R is intended to be run in a working directory into which the target data has already been downloaded. In order to obtain the data, run the following steps in R:  
1. download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip', destfile='uci_har_data.zip')  
2. unzip('uci_har_data.zip')  
3. setwd('UCI HAR dataset')  

Then, to perform the analysis:  
4. source('/path/to/run_analysis.R')  

Notes on the analysis:
* run_analysis.R collects the variables from the original data with identifiers containing the words 'mean' or 'std' (case-insensitive), and then, for each test subject performing each activity, calculates the mean of every variable of interest.  
* There is some discussion in the course forum about whether to include all columns containing 'Mean', 'mean()', etc., or to just use the columns that have associated standard deviations. Since no use case is provided for this data, it is not possible to say what the 'right' answer is. However, since it is always possible to discard unwanted data, but not necessarily to recover lost data, all 'mean' columns are included here.  
* The original data contain some variables with names like 'fBodyBody...', which are not mentioned in the original data's documentation. There are descriptions of variables with out the repeated 'Body'. It is assumed that this is an error, and so every variable name like 'fBodyBody...' has been changed to 'fBody...'  
* By default, R converts non-alphanumeric characters to dots in column names, which leads to some rather hard-to-read names in this data set. To avoid this, runs of non-alphanumeric characters in the variable names are changed to single dots.  

See the documentation in run_analysis.R for details.

[1]: Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012  
[2]: http://vita.had.co.nz/papers/tidy-data.pdf
