# Create with golem::create_golem(path =".") 
# Building a Prod-Ready, Robust Shiny Application.
# 
# README: each step of the dev files is optional, and you don't have to 
# fill every dev scripts before getting started. 
# 01_start.R should be filled at start. 
# 02_dev.R should be used to keep track of your development during the project.
# 03_deploy.R should be used once you need to deploy your app.
# 
# 
########################################
#### CURRENT FILE: ON START SCRIPT #####
########################################

## Fill the DESCRIPTION ----
## Add meta data about your application
## 
## /!\ Note: if you want to change the name of your app during development, 
## either re-run this function, call golem::set_golem_name(), or don't forget
## to change the name in the app_sys() function in app_config.R /!\
## 
#golem::fill_desc(
#  pkg_name = "stacoshiny", # The Name of the package containing the App 
#  pkg_title = "User interface for stacomi", # The Title of the package containing the App 
#  pkg_description = "It is a part of the 'STACOMI' open source project developed in France by the French Agency for Biodiversity (OFB) institute, to centralize data obtained by fish pass monitoring. The objective of the stacomi project is to provide a common database for people monitoring ï¬�sh migration, so that data from watershed are shared, and stocks exchanging between diï¬€erent basins are better managed. ", # The Description of the package containing the App 
#  author_first_name = "AUTHOR_FIRST", # Your First Name
#  author_last_name = "AUTHOR_LAST", # Your Last Name
#  author_email = "AUTHOR@MAIL.COM", # Your Email
#  repo_url = "https://forgemia.inra.fr/stacomi/stacoshiny" # The URL of the GitHub Repo (optional) 
#)     

## Set {golem} options ----
#golem::set_golem_options()

## Create Common Files ----
## See ?usethis for more information
#usethis::use_mit_license( "Golem User" )  # You can set another license here
usethis::use_readme_rmd( open = TRUE )
#usethis::use_code_of_conduct(contact = )
usethis::use_lifecycle_badge( "stable" )
usethis::use_cran_badge()
#usethis::use_news_md( open = FALSE )


## Use git ----
usethis::use_git()

## Init Testing Infrastructure ----
## Create a template for tests
#golem::use_recommended_tests()
#
### Use Recommended Packages ----
#golem::use_recommended_deps()

## Favicon ----
# If you want to change the favicon (default is golem's one)
#golem::use_favicon(path = "https://stacomir.r-forge.r-project.org/images/stacomi_logo.png") # path = "path/to/ico". Can be an online file. 
##golem::remove_favicon()
#
### Add helper functions ----
#golem::use_utils_ui()
#golem::use_utils_server()

# You're now set! ----

# go to dev/02_dev.R
#rstudioapi::navigateToFile( "dev/02_dev.R" )

