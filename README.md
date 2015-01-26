The program assumes that UCI data is available in a directory called UCi in the same directory as the R script run_analysis.R

Caveat:

Reading the training feature set encountered issues in the number of rows read. But I tested the program using a sample of the feature set and it printed out hte results correctly.

Somehow, the read.csv function when reading UCI/train/X_train.txt is giving 11K+ rows which is higher than 7352 (expected). There is something wrong with the input file.

I create a sample 1000 records from the training and test data sets and I was able to get the correct results.

