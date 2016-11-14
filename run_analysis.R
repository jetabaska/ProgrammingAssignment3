library(dplyr)
library(stringr)

# Per the problem statement, it is assumed that the Samsung data has been downloaded
# and unzipped and exists in the current working directory.

# Read feature names
raw_features = read.table('features.txt', stringsAsFactors = FALSE)

# Edit the feature names to make things easier to read:
#   - change the 'fBodyBody' names (which aren't mentioned in the original
#     documentation) to 'fBody' (which are presumably what the authors meant)
#   - replace runs of non-alphanumerics to single dot characters, to avoid
#     R's rather hideous default substitutions
#   - strip trailing dots from step 2
features =
    tbl_df(raw_features) %>% 
    transmute(name = str_replace(V2, 'fBodyBody', 'fBody')) %>%
    transmute(name = str_replace_all(name, '[^A-Za-z1-9]+', '.')) %>%
    transmute(name = str_replace(name, '\\.', ''))

# Read activity names
activity_labels = read.table('activity_labels.txt')

# read_data(): Given a group name (test or train), perform the following:
#   - read the measurements (X_*.txt) data
#   - read the activity ID (y_*.txt) data
#   - read the subject ID (subject_*.txt)
#   - convert the activity IDs to activity names
#   - collect the activity names, subject IDs, and measurements column-wise into
#     a single data frame
read_data = function(group) {
    x_file = str_replace_all('GRP/X_GRP.txt', 'GRP', group)
    y_file = str_replace_all('GRP/y_GRP.txt', 'GRP', group)
    sbj_file = str_replace_all('GRP/subject_GRP.txt', 'GRP', group)

    x_data = tbl_df(read.table(x_file, col.names=features$name))
    y_data = tbl_df(read.table(y_file))
    subjects = tbl_df(read.table(sbj_file, col.names='subject'))
    
    activities = transmute(y_data, activity = activity_labels[V1,2])

    bind_cols(activities, subjects, x_data)
}

# Read the test and train data sets and merge into a single data frame
test_data = read_data('test')
train_data = read_data('train')
all_data = bind_rows(test_data, train_data)

# Find the columns with 'mean' or 'std' in their names. Case-insensitive, so
# it will includes both fields with names like '.mean()' and 'gravityMean'.
# This may or may not be proper, depending on the application, but it is always
# easier to discard data you don't want than to get data you don't have.
mean_std_data =
    select(all_data, matches('subject|activity|mean|std', ignore.case=TRUE))

# Create a second, independent tidy data set with the average of each variable
# for each activity and each subject.
by_subject_and_activity = group_by(mean_std_data, subject, activity)
result = summarize_all(by_subject_and_activity, mean)

write.table(result, file='result.txt', row.names=FALSE)
