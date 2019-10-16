# Requirements
The script depends on the following packages:
* dplyr
* tidyr

# Running the script
The script run_analysis.R has to be placed in the same root folder as *UCI HAR Dataset*, and not inside of it.

# Output
An analysis_output.csv file with the ";" field separator. The file is structured as follows:
* Column 1: subject.
* Column 2: activity.
* Columns 3-n: the mean of the observations for each group (subject x activity).
