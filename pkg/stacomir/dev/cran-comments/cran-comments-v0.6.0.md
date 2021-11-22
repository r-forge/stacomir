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

With no error, no warnings and 1 note : "the package was archived on CRAN due to dependency on gwidget."
> stacomir based on gwidget was dropped from CRAN in May 2020, it has been completely reprogrammed to remove all dependence to
gwidget

* Windows r-4.1.2 (my local machine) 
* ubuntu (current rocker/tidyverse) https://forgemia.inra.fr/stacomi/stacomir/-/pipelines/44482 
* pc-linux-gnu (R 4.1.2) R-Forge

using rhub::check_for_cran()

* Fedora Linux, R-devel, clang, gfortran 
* Ubuntu Linux 20.04.1 LTS, R-release, GCC
* Windows Server 2008 R2 SP1, R-devel, 32/64 bit 



## NEWS 0.6.0


stacomir based on gwidget was dropped from CRAN in May 2020, it has been completely reprogrammed to remove all dependence to
gwidget and the graphical interface will be a new shiny package (under developpement). Stacomirtools has been rewritten and submitted to CRAN 
to connect via pool and DBI.

* Rewrote classes for connections using DBI and pool.
* The connection settings can now be made using options.
* Added unit tests to all classes.
* now documented using Roxygen.
* Connector classes using RODBC are now marked as deprecated and will fire note
  deprecated.

