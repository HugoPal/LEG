# LEGtool: Predicting end of larval period for grayling

LEGtool is a modelling approach for lab-raised European Grayling _Thymallus thymallus_ to predict when an individual will end the larval period and its length at that point.

Details of the tool are available in Palejowski et al. (_in prep_)

## Getting started

### Prerequisites

LEGtool was developed using R version 4.0.2.
It uses the following packages:
 - tibble version 3.0.4
 - readr version 1.4.0

To use the tool download the code from the main LEG repository via Download ZIP. 
Your data must be formatted as a .csv file named `DATAFRAME.csv` and placed in the `data/` directory following the formatting details provided in `data/README.md`. 

### Usage

The tool provided in `LEGtool_1.4.R` can then either be run using RStudio line by line or from the command line.

The following diagram illustrates the structure of LEGtool. The input data, processed as described in `data/`, is used as an input to fit the yolk sac consumption model. The user is able to select among two such models (see details below). This model generates the timing of the end of the larval stage for an individual which, combined with the individual's initial input data, is used to fit the growth model and finally predict the length at the end of the larval stage.

![](images/diagram_user.png)

Palejowski et al (_in prep_) developed two models of yolk sac consumption, model 1 (linear relationship between time and yolk sac consumption, simpler but slightly less accurate) and model 2 (non-linear relationship, more complex but more accurate). Model 1 is used by default, but model 2 can be used by loading `"predictor_timing_of_yolk_period_end_b.rds"` instead of `"predictor_timing_of_yolk_period_end.rds"` in line 44 of `LEGtool_1.4.R`. Discussion of the two models is in Palejowski et al (_in prep_).

Verify that the data adheres to the specified formatting, as described in `data/`, ensure the correct packages are installed, choose which timing predictor model to use, then either run `LEGtool_1.4.R` from the command line or run line 53 in RStudio. This will generate your predicted values, which are then saved later in the script if running line-by-line. Histograms of predicted results are generated and saved lower in the script.

Running LEGtool generates the following outputs, saved in `outputs/`:

| Output | Description | 
| --- | --- |
| `DATAFRAME_predicted.csv` | The original input `DATAFRAME.csv` file but with two added columns of predicted lengths at larval period end, and of predicted time of larval period end in days post fertilisation. |
| `histogram_of_predicted_times.png` | A histogram of the predicted timings of end of larval period, saved as a .png file. |
| `histogram_of_predicted_lengths.png` | A histogram of the predicted lengths at end of larval period, saved as a .png file. |

_DISCLAIMER:_ LEGtool has been fitted on input data within the ranges provided below. Input data that includes values outside of these ranges may generate unreliable predictions:
 - fish length at hatching: 8.419-10.677 mm
 - number of days taken to hatch: 30-38
 - yolk sac volume at hatching: 5.5-11.9 mm<sup>3</sup>
 - length of experiment: 30-70 days post-fertilisation

## Citing

The paper is currently in preparation. This section will be updated when it is citable.

## License

Usage is provided under the [MIT License](https://github.com/HugoPal/LEG/blob/main/LICENSE).
