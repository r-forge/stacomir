# Stacomir0.6.0.1

## RESUBMISSION

This is a new release of stacomir


## TESTS

Passing all tests on my local machine (windows) R4.1.2 (requires a database installed)
   
* [ FAIL 0 | WARN 0 | SKIP 0 | PASS 293 ]
* code coverage : 84 %

## CHECKS

With no error, no warnings on my machine and no note in CRAN "the package was archived on CRAN due to dependency on gwidget."

using rhub : I have troubles and warnings in Rhub, cannot connect windows, and on Solaris and macos the version is 4.1.1.
So the warnings come as packages were built under R version 4.1.2. I cannot check the package in 
rhub::check_for_cran()
Error in match_platform(platform) : 
  Unknown R-hub platform, see rhub::platforms() for a list, and windows is not listed


* Windows r-4.2.1 (my local machine) [0 errors v | 0 warnings v | 0 note v]
* Windows rforge [0 errors v | 0 warnings v | 1 note x] (new submission)
* linux  rforge [0 errors v | 0 warnings v | 1 note x] (new submission)
* solaris-x86-patched:  [1 errors x ] : Package suggested but not available: ‘testthat’
* macOS 10.13.6 High Sierra [0 errors v | 3 warnings v | 1 note x] : warnings : packages built 4.1.2, note : found 40748 marked UTF-8 strings


## NEWS 0.6.7

stacomir based on gwidget was dropped from CRAN in May 2020, it has been completely reprogrammed to remove all dependence to gwidget and the graphical interface is now a shiny package . stacomirtools has been rewritten and submitted to CRAN to connect via pool and DBI. A first submission was done in november, and then we have waited to finish the development of the shiny package before resubmitting.



