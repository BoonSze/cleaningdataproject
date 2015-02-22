#How the script works

This script:
  - Reads in all test and training files
  - Combines Training and Testing data
  - Renames the columns in subject data set and activity dataset
  - Renames all the columns in features dataset
  - Selects only the columns with mean or std
  - Combine all Subject, Activity and features into 1 dataset
  - Sort by Subject then Activity
  - Uses descriptive activity names e.g. WALKING, WALKING_UPSTAIRS, etc.
  - Creates a 2nd tidy data set with average of each variable for each activity and each subject
