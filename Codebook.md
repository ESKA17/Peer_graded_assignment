# Codebook

This codebook breaks down algorithm of code run_analysis.R. The algorithm has 
the following key steps:

1. Downloading and unziping data from a given [link](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) to a folder *UCI HAR Dataset*. Prior downloading it checks whether the data has been already downloaded.
2. Using command `read.table` reading and writing the following data: 
- **features.txt** to a `data_names` (chr [1:561]) that is lately used for naming columns of output data. The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ.
- **activity_labels.txt** to a data frame `activity_label` (6x2 df). This data frame links the class labels with their activity name.
- **subject_test.txt** and **subject_train.txt** to a data frames `subject_test` (2947x1 df) and `subject_train` (7352x1 df), respectively. Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
- **X_test.txt** and **X_train.txt** to a data frames `x_test` (2947x561 df) and `x_train` (7352x561 df), respectively. Test and training sets' data is collected here. Names for columns are taken from `data_names`.
- **Y_test.txt** and **Y_train.txt** to a data frames `y_test` (2947x1 df) and `y_train` (7352x1 df), respectively. These data sets contain training activity number.
3. Using `factor` and `sapply` commands on `activity_label`, `y_test` and `y_train` dataframes, character labels are assignd to each observation of both test and train datasets creating new data frames called `y_test_labeled` (chr [1:2947]) and `y_train_labeled` (chr [1:7352]).
4. Using `cbind` command, above data frames are column binded to a `subject_test` and`subject_train` data sets, respectively, creating data frame with subject number and activity done during each observation for both test and training sets. New data frames were named `test_subj_act_label` (2947x2 df) and `train_subj_act_label` (7352x2 df).
5. Using `rbind` command, `x_test` and `x_train` data frames were row binded together to form a new data frame called `x_data` (10299x561 df). The same way`y_data` (10299x2 df) was created from `y_test` and `y_train` data frames.
6. Again using `cbind` command `merged_data` (10299x563 df) was obtained by binding  `y_data` and `x_data` together.
7. Using `select`, only first two columns and columns that contain *mean* and *std* in the name were selected to form new data frame called `mean_sd_data` (10299x88 df)
8. using `gsub` command, namings of almost all columns were cleaned based on the specific pattern shown in the code.
9. Finally, the following code:
```mean_sd_data %>% group_by(Subject, Activity) %>% summarise_all(.funs = mean)```
was used in order to obtain new data fram `average_data` (180x88 df) containing means (using command `summarise_all`) and grouped by *Subject* and *Activity* (using command `group_by`)
10. Finally, `average_data` was written to a file **average_data.txt** using command `write.table`

