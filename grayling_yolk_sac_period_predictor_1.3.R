### Tool to predict timing of the end of the yolk sac period, and fish length at that point, in grayling, based on length at hatching, how many days a fish took to hatch, and yolk sac volume at hatching.
# DISCLAIMER: as with all predictive models, this tool will predict well if the input variables are within the range used to train the original model, outside of the below ranges predictions cannot be trusted:
#   - fish length at hatching: 8.419-10.677 mm
#   - number of days taken to hatch: 30-38
#   - yolk sac volume at hatching: 5.5-11.9 mm^3

### Data formatting:
# data must be in format of one row per fish. 
# The data must contain the following columns: "fish_ID", "incubation", "hatchlength", "hatchvolume", where fish_ID is an individual's unique ID, incubation is the number of days an individual took to hatch, hatlength is the length at hatching, and hatchvolume is the yolk sac volume at hatching.
# "fish_ID" must be coded as.character. "incubation", "hatchlength", "hatchvolume" must be as.numeric.
# An example dataset is given here.
if(!require(tidyverse)){
  install.packages("tidyverse")
  library(tidyverse)
}
if(!require(ggpubr)){
  install.packages("ggpubr")
  library(ggpubr)
}

tibble("fish_ID" = c(seq(1,5,1)),
       "incubation" = c(31,36,34, 33, 38),
       "hatchlength" = c(runif(5, min=7.906,max=10.677)),
       "hatchvolume" =c(runif(5, min=5.5, max=11.9)))

# FIRST load your data, it must follow data formatting given above
DATAFRAME <- read_csv()

### Run tool
# NEXT load timing and length predictors ENTER THEIR LOCATIONS HERE
# two timing predictors are available (models 1 and 2 from Palejowski et al.), you can choose which you would like to use
timing_predictor <- readRDS(file = "C:/Users/hpalejow/Documents/Work/Uni Work/Lausanne PhD/2 Growth curve salmonids/Grayling/predictor_timing_of_yolk_period_end.rds") #ENTER THE LOCAITON OF predictor_timing_of_emergence.rds FILE
length_predictor <- readRDS(file = "C:/Users/hpalejow/Documents/Work/Uni Work/Lausanne PhD/2 Growth curve salmonids/Grayling/predictor_length_at_yolk_period_end.rds") #ENTER THE LOCATION OF length_timing_of_emergence.rds FILE

# the predictor tool
unique_fish_ids <- unique(DATAFRAME$fish_ID)
end_of_yolk_sac_period_results <-tibble("fish_ID"=unique_fish_ids,
                                        "emergence_date"=NA,
                                        "emergence_length"=NA)

for(i in 1:length(unique_fish_ids)) {
  
  ID_of_fish = unique_fish_ids[i]
  days_taken_to_hatch =DATAFRAME$incubation[i]
  yolk_sac_volume_at_hatching_mm3 =DATAFRAME$hatchvolume[i]
  fish_length_at_hatching_mm =DATAFRAME$hatchlength[i]
  
  end_of_yolk_sac_period_results$fish_ID
  
  ## day of end of yolk-sac period (when yolk sac volume = 20% of volume at hatching - can change this threshold in the propYSrem= )
  time_plot_models_data_point<-tibble(
    fish_ID=ID_of_fish,
    incubation=days_taken_to_hatch,
    hatchvolume=yolk_sac_volume_at_hatching_mm3,
    hatchlength=fish_length_at_hatching_mm,
    propYSrem=0.2
  )
  
  time_plot_models_predict_point<-predict(timing_predictor, time_plot_models_data_point, allow.new.levels=T) 
  end_of_yolk_sac_period_results$emergence_date[end_of_yolk_sac_period_results$fish_ID==ID_of_fish]<- time_plot_models_predict_point
  
  ## length at end of yolk-sac period (when yolk sac volume = 20% of volume at hatching)
  length_plot_models_data_point<-tibble(
    fish_ID=ID_of_fish,
    incubation=days_taken_to_hatch,
    hatchvolume=yolk_sac_volume_at_hatching_mm3,
    hatchlength=fish_length_at_hatching_mm,
    days_post_fertilisation=time_plot_models_predict_point,
    log_dpf=log(time_plot_models_predict_point)
  )
  
  length_plot_models_predict_point<-predict(length_predictor, length_plot_models_data_point, allow.new.levels=T) 
  end_of_yolk_sac_period_results$emergence_length[end_of_yolk_sac_period_results$fish_ID==ID_of_fish] <- length_plot_models_predict_point
  
}

# get results
end_of_yolk_sac_period_results

range(end_of_yolk_sac_period_results$emergence_date)
range(end_of_yolk_sac_period_results$emergence_length)
hist(end_of_yolk_sac_period_results$emergence_date)
hist(end_of_yolk_sac_period_results$emergence_length)

# merge results with dataset
merge(DATAFRAME, end_of_yolk_sac_period_results, by = "fish_ID", all=T)

# plot results
DATAFRAME_fish_emergence_histos<-ggarrange(
  ggplot(tibble(end_of_yolk_sac_period_results$emergence_date), aes(end_of_yolk_sac_period_results$emergence_date)) +
    geom_histogram(binwidth = 0.05,
                   col="black",
                   fill="grey") +
    xlab("Time to end of yolk-sac period (days post-fertilisation)") +
    theme(axis.line = element_line(size = 0.5, linetype = "solid", colour = "black"),
          panel.grid = element_blank(),
          panel.background = element_blank(),
          axis.title = element_text(size=12),
          panel.border = element_rect(colour = "black", fill=NA, size=1)) +
    scale_x_continuous(breaks = seq(58, 65, by = 0.1), limits = c(58,65)),
  ggplot(tibble(end_of_yolk_sac_period_results$emergence_length), aes(end_of_yolk_sac_period_results$emergence_length)) +
    geom_histogram(binwidth = 0.1,
                   col="black",
                   fill="grey") +
    xlab("Length at end of yolk-sac period (mm)") +
    theme(axis.line = element_line(size = 0.5, linetype = "solid", colour = "black"),
          panel.grid = element_blank(),
          panel.background = element_blank(),
          axis.title = element_text(size=12),
          panel.border = element_rect(colour = "black", fill=NA, size=1)) +
    scale_x_continuous(breaks = seq(11, 15, by = 0.2), limits = c(12,14.5)),
  ncol=1,
  labels = "AUTO")
DATAFRAME_fish_emergence_histos


