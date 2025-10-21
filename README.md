
# Study_design_app

<!-- badges: start -->
<!-- badges: end -->

The goal of the study design app is to allow a user to plan an study inclding determining how many subjects are needed and a budget. The package includes tabs to calculate sample size, budget and an option for visualization of sample size. 

## Link to app

The recommended way to use this app is to visit the site https://019a0496-1019-409b-4f76-03d5b2bb7a2e.share.connect.posit.cloud/ . You can then select your desired parameters and it will return a sample size. You can then input the sample size calculated into the budget calculator and find out how much a study of that size will cost.


## Installation

If you want to run the app from the code: first you need to install the 

You can install the development version of hw4 from [GitHub](https://github.com/sarahunsberger1/hw4_package).

You can use the following code to install it:

```{r, eval = FALSE}
if (!require("devtools", quietly = TRUE)) {
    install.packages("devtools")   
}

library(devtools)

devtools::install_github("sarahunsberger1/hw4_package", build_vignettes = TRUE)
```

Then you need to install shiny, bslib and ggplot2 from CRAN. Finally, you can clone this repository and run the app from the code. 
