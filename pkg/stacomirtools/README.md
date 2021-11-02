
<!-- README.md is generated from README.Rmd. Please edit that file -->

# stacomirtools

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/stacomirtools)](https://CRAN.R-project.org/package=stacomirtools)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
<!-- badges: end -->

The goal of stacomirtools is to …

## Installation

You can install the development version of stacomirtools like so:

``` r
#install.packages("remotes")
#remotes::install_github(repo= "Remotes: gitlab::git@forgemia.inra.fr:stacomi/stacomirtools.git")
install.packages("stacomirtools", repos="http://R-Forge.R-project.org")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(stacomirtools)
options(list(
                        stacomi.path = "~",
                        stacomi.dbname = "bd_contmig_nat",
                        stacomi.host ="localhost",
                        stacomi.port = "5432",
                        stacomi.user = "mysuser",
                        stacomi.password = "mypassword",
                        stacomi.ODBClink = NULL,
                        stacomi.printqueries =FALSE
                ))
req <- new("RequeteDB")
req <- query(req)
```
