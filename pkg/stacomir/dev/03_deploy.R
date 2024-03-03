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
# setwd("C:\\workspace\\stacomir")
# Test your app
# options("stacomiR.printqueries"=TRUE)
rm(list=ls(all.names = TRUE))
#formatR::tidy_dir(path="/inst/examples")
devtools::load_all() 
Sys.setenv("LANGUAGE" = "en") # otherwise problems when running from Rstudio
options(					
		stacomiR.dbname = "bd_contmig_nat_test",
		stacomiR.host ="localhost",
		stacomiR.port = "5432",
		stacomiR.user = "test",
		stacomiR.password = "test"				
)

# GO TO helper.R called before everything to change options.
devtools::test() # this will run load_all() see details about classes below for specific tests
#test_local() # check a package during R CMD check
test <- capture.output(devtools::test(reporter="junit")) 
# pour gitlab
XML::saveXML(XML::xmlParse(test[grep("?xml version",test):length(test)]), file="C:/temp/test.xml")
co <- covr::package_coverage(type="all", quiet=FALSE, clean=FALSE)
covr:::print.coverage(co)
covr::report(co, file.path("dev/codecoverage_report", paste0("stacomiR-report.html")))
# this is only 42 % without NOT_CRAN"
devtools::test_coverage(type="all", quiet=FALSE, clean=TRUE) # 78 => 85 # devtools::test_coverage(file = "dev/coverage.html")


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
devtools::build_vignettes() # TODO remettre eval=TRUE pour code 
## Run checks ----
## Check the package before sending to prod

devtools::document()
tools::update_pkg_po(getwd())
# TODO use poedit to open po file save mo file when finished


devtools::check()
devtools::check_man()
devtools::check(args="run-dontrun")
devtools::check( env_vars = c(NOT_CRAN = "false")) 
# TO SKIP THE TEST AS IN CRAN where skip_on_cran()
# and try to figure out where tests fail on CRAN

devtools::check_rhub()
  # this type 10 or 11 or 12
devtools::check_win_devel()
devtools::check_mac_release()
rhub::check(".")
rhub::check_on_windows()
rhub::check(platform="macos-highsierra-release-cran")
rhub::check_for_cran()
rhub::check(platform = 'ubuntu-rchk')
rhub::check_with_sanitizers()
# Deploy

## Local, CRAN or Package Manager ---- 
## This will build a tar.gz that can be installed locally, 
## sent to CRAN, or to a package manager
devtools::build()
devtools::spell_check()
tools::showNonASCIIfile("data/coef_durif.rda")
tools:::.check_package_datasets(".")
devtools::release()
devtools::install()


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
