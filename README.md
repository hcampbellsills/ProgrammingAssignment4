# Scope of the script
To download data collected from the accelerometers from the Samsung Galaxy S smartphone (if not already downloaded), merge the training and test data sets, use descriptive labels for observations and measurements, extract only the measurments of the means and standard deviation, and create a table summarising the mean of each selected measurement by group (subject x activity).

# Requirements
The script depends on the following packages:
* dplyr
* tidyr

# Running the script
The script run_analysis.R has to be placed in the same root folder as *UCI HAR Dataset*, and not inside of it.

## Details on how the script works
Check directly into the script's code for the comments on each step.

# Output files
/!\ Note: an output directory with an example of data generated with this script is providen in the repository.

After running the script, the following files are generated:
* output/Inertial Signals/*.txt: one merged file for the train and test sets for each of the files contained in the *Inertial Signals* folder.
* output/X.txt: one merged file for the X_train.txt and X_test.txt files.
* output/subject.txt: one merged file for the subject_train.txt and subject_test.txt files.
* output/y.txt: one merged files for the y_train.txt and y_test.txt files.
* output/summarised_data.csv: a csv file using the ";" field separator and containing the means for each group of observations (subject x activity). The file is structured as follows:
    * Column 1: subject.
    * Column 2: activity.
    * Columns 3-n: the mean of the observations for each group (subject x activity).
