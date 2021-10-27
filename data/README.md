Your data will go in this folder, it needs to be formatted as described below or the tool will not work.

The data must be named `DATAFRAME.csv` and be formatted as a CSV file.

The data must contain the following columns:
"fish_ID" - unique identifier for a fish
"incubation" - the number of days an individual took to hatch
"hatchlength" - length at hatching
"hatchvolume" - yolk sac volume at hatching

"fish_ID" must be coded as.character
"incubation", "hatchlength", "hatchvolume" must be as.numeric.

An example dataset is given here:
| fish_ID | incubation | hatchlength | hatchvolume |
| --- | --- | --- | --- |
| chr | num | num | num |
| 1 | 31 | 8.87 | 6.64 |
| 2 | 36 | 8.61 | 10.3 |
| 3 | 34 | 8.13 | 9.90 |
| 4 | 33 | 8.16 | 6.09 |
| 5 | 38 | 10.2 | 5.65 |
