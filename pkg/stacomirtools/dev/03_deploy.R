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

## Run checks ----
## Check the package before sending to prod
#usethis::use_build_ignore(".dbeaver")
# delete namespace before loading again...
devtools::load_all()
devtools::document()
devtools::build_readme()
devtools::test()

#roxygen2::roxygenise(clean = TRUE) # marche pas si les .Rd ont été écrits à la main il faut les supprimer
Sys.setenv("NOT_CRAN"= "false") # to set checks without testhat testthat
devtools::check()
rhub::check_for_cran()

previous_checks <- rhub::list_package_checks(
		email = "cedric.briand00@gmail.com",
		howmany = 4)
group_id <- previous_checks$group[1]
group_check <- rhub::get_check(group_id)
group_check$browse()
# Deploy

## Local, CRAN or Package Manager ---- 
## This will build a tar.gz that can be installed locally, 
## sent to CRAN, or to a package manager
devtools::build()
devtools::install()


