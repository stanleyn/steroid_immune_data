## Purpose: 

Perform computational analysis from Ganio et al. looking at the effects of steroids on the immune system after surgery. We used the VoPo clustering algorithm (https://github.com/stanleyn/VoPo) to generate immune features from the 331 samples available on flow repository (https://flowrepository.org/id/FR-FCM-Z2AT).

## Date 

May 11, 2020

## Questions
Please contact Natalie Stanley (NatalieStanley1318@gmail.com) with any questions

## Instructions
- This code was implemented and tested in R version 3.4.4 and uses randomForest version 4.6-14. 

- Before getting started, please make sure you have the following dependencies installed in R (`Biobase`, `randomForest`, `pROC`, `plyr`, `foreach`, `doParallel`, `ggplot2`, `reshape2`, `plyr`)

- You have downloaded this directory and into some location **YourPath**. Start R, and change into the **YourPath** directory

```r
> setwd('YourPath')
```
-You can use the script RF_PerTP.R to create a random forest model for each individual timepoint

```r
> source('RF_PerTP.R')
```

- When this is finished running, you can see the vector of AUCs and Wilcoxon p-values corresponding to the predictive power of the model learned for each timepoint (Pre, 1hr, 6hr, 24r, 48hr, and 2 wks after surgery)

- To see AUCs,

```r
> AUC
```
- To see Wilcoxon p-values,

```r
> Wilcox
```
- A plot of boxplots per timepoint will be generated to the main steroid_immune_data folder called steroid_classif.pdf
