# Stacomir0.6.0

Dear CRAN administrator

This is a new release of stacomir for integration on CRAN.

Sincerely yours

Cédric Briand

## TESTS

Passing all tests on my local machine (windows) R4.1.2 (requires a database installed)
   
* [ FAIL 0 | WARN 0 | SKIP 0 | PASS 243 ]
* code coverage : 78 %

## CHECKS

With no error, no warnings and 1 note in CRAN "the package was archived on CRAN due to dependency on gwidget."

> stacomir based on gwidget was dropped from CRAN in May 2020, it has been completely reprogrammed to remove all dependence to
gwidget. In Rforge windows, build fails and the error comes from stacomirtools 0.6.0 not yet available.

Current version

* Windows r-4.1.2 (my local machine) [0 errors v | 0 warnings v | 0 note v]
* ubuntu (current rocker/tidyverse) https://forgemia.inra.fr/stacomi/stacomir/-/pipelines/44482  [0 errors v | 0 warnings v | 1 note x]
* pc-linux-gnu (R 4.1.2) R-Forge [0 errors v | 0 warnings v | 1 note x]
* pc-linux-gnu (R 4.1.2) [0 errors v | 0 warnings x | 1 note x]
* R-Forge Windows binary (x86_64/i386) [1 errors x | 0 warnings x | 1 note x] 
Error: package 'stacomirtools' 0.5.3 was found, but >= 0.6.0 is required by 'stacomiR'

Development version

using rhub::check_for_cran()

* Fedora Linux, R-devel, clang, gfortran [0 errors v | 0 warnings v | 1 note x]
* Ubuntu Linux 20.04.1 LTS, R-release, GCC [0 errors v | 0 warnings v | 1 note x]
* Windows Server 2008 R2 SP1, R-devel, 32/64 bit [0 errors v | 0 warnings v | 1 note x]

## NEWS 0.6.0

stacomir based on gwidget was dropped from CRAN in May 2020, it has been completely reprogrammed to remove all dependence to
gwidget and the graphical interface will be a new shiny package (under developpement). Stacomirtools has been rewritten and submitted to CRAN 
to connect via pool and DBI.

* added import to package  `rlang` 
* Change to adapt to new dplyr format `dplyr:n()` instead of `n()` see dplyr breaking change in version 1.0.0
* adapted to stacomirtools new connection and connection options (using pool and DBI instead of RODC)
* removed all dependency to gwidgetRGTK2 so in practise there is no longer a graphical interface, the shiny package is due soon.
* added code of conduct
* rewrote unit tests increased coverage from 50 to 78 %

