# Building a Prod-Ready, Robust Shiny Application.
# 
# README: each step of the dev files is optional, and you don't have to 
# fill every dev scripts before getting started. 
# 01_start.R should be filled at start. 
# 02_dev.R should be used to keep track of your development during the project.
# 03_deploy.R should be used once you need to deploy your app.
# 
# 
######################################
#### CURRENT FILE: DEPLOY SCRIPT #####
######################################

# Test your app
rm(list=ls(all.names = TRUE))
#formatR::tidy_dir(path="/inst/examples")
devtools::load_all() 

devtools::test() # this will run load_all() see details about classes below for specific tests

devtools::test_coverage()
devtools::document()
Sys.setenv("NOT_CRAN"= "true")

source(stringr::str_c(getwd(),"/tests/testthat/helper.R"))
test_file(stringr::str_c(getwd(),"/tests/testthat/test-00-stacomir.R"))
test_file(stringr::str_c(getwd(),"/tests/testthat/test-00-zrefclasses.R"))
test_file(stringr::str_c(getwd(),"/tests/testthat/test-01-report_mig_mult.R"))
test_file(stringr::str_c(getwd(),"/tests/testthat/test-02-report_mig.R"))
test_file(stringr::str_c(getwd(),"/tests/testthat/test-03-report_df.R"))
test_file(stringr::str_c(getwd(),"/tests/testthat/test-04-report_dc.R"))
test_file(stringr::str_c(getwd(),"/tests/testthat/test-05-report_sample_char.R"))
test_file(stringr::str_c(getwd(),"/tests/testthat/test-06-report_mig_interannual.R"))
test_file(stringr::str_c(getwd(),"/tests/testthat/test-07-report_sea_age.R"))
test_file(stringr::str_c(getwd(),"/tests/testthat/test-08-report_silver_eel.R"))
test_file(stringr::str_c(getwd(),"/tests/testthat/test-09-report_annual.R"))
test_file(stringr::str_c(getwd(),"/tests/testthat/test-10-report_env.R"))
test_file(stringr::str_c(getwd(),"/tests/testthat/test-11-report_mig_env.R"))
test_file(stringr::str_c(getwd(),"/tests/testthat/test-12-report_mig_char.R"))
test_file(stringr::str_c(getwd(),"/tests/testthat/test-13-report_species.R"))
test_file(stringr::str_c(getwd(),"/tests/testthat/test-14-report_ge_weight.R"))
devtools::build_readme()
devtools::build_vignettes()
## Run checks ----
## Check the package before sending to prod
devtools::check()
devtools::check( env_vars = c(NOT_CRAN = "false")) 
# TO SKIP THE TEST AS IN CRAN where skip_on_cran()
# and try to figure out where tests fail on CRAN
rhub::check_for_cran()

# Deploy

## Local, CRAN or Package Manager ---- 
## This will build a tar.gz that can be installed locally, 
## sent to CRAN, or to a package manager
devtools::build()

## RStudio ----
## If you want to deploy on RStudio related platforms
golem::add_rstudioconnect_file()
golem::add_shinyappsio_file()
golem::add_shinyserver_file()

## Docker ----
## If you want to deploy via a generic Dockerfile
golem::add_dockerfile()

## If you want to deploy to ShinyProxy
golem::add_dockerfile_shinyproxy()

## If you want to deploy to Heroku
golem::add_dockerfile_heroku()
