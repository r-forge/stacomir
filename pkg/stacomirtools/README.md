
<!-- README.md is generated from README.Rmd. Please edit that file -->

# stacomirtools

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/stacomirtools)](https://CRAN.R-project.org/package=stacomirtools)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![Downloads](https://cranlogs.r-pkg.org/badges/stacomirtools)](https://cran.r-project.org/package=stacomirtools)
<!-- badges: end -->

Stacomirtools provides S4 class wrappers for DBI pool and ODBC,
essentially managing database connections for stacomiR plus one or two
handy functions.

## Installation

You can install the development version of stacomirtools like so:

``` r
#install.packages("remotes")
#remotes::install_github(repo= "Remotes: gitlab::git@forgemia.inra.fr:stacomi/stacomirtools.git")
install.packages("stacomirtools", repos="http://R-Forge.R-project.org")
```

## Example

The connection is established via options, for ODBC connections you need
to setup the ODBC connection corresponding to your version of R (either
32 or 64 bits). You need to specify user and password.

``` r
library(stacomirtools)
# all options :
options(list(
                        stacomiR.dbname = "bd_contmig_nat",
                        stacomiR.host ="localhost",
                        stacomiR.port = "5432",
                        stacomiR.user = "mysuser",
                        stacomiR.password = "mypassword",
                        stacomiR.ODBClink = NULL,
                        stacomiR.printqueries =FALSE
                ))
req <- new("RequeteDB")
req <- query(req)
```

## Pool Connection

For Pool, if you are running on your machine (localhost) and use
postgres standard 5432 port, you need only to set options for dbname,
user and password, otherwise you can connect to different hosts.

``` r
options(list(   
                stacomiR.user = "mysuser",
                stacomiR.password = "mypassword"                
        ))
# if you don't provide those you will be prompted for user and password if interactive
req <- new("RequeteDB")
req <- query(req)
# The query result is stored in req@query you can use either
req@query
# or
getquery(req)
# to get it
```

## ODBC Connection

In windows establish ODBC link by typing ODBC in the search bar, then
choose either 32 bit or 64 bit, user source add POSTGRESQL ODBC Driver
(these must be prior installed with postgres via application stack
manager). Then edit the datasource for the following fields. \* Data
Source : the name of the stacomiR.ODBClink below \* Database \* Serveur
: on you computer `localhost` \* User Name \* Password \* Port

``` r
options(list(   
                stacomiR.ODBClink = "bd_contmig_nat",
                stacomiR.user = "mysuser",
                stacomiR.password = "mypassword"                
        ))
req <- new("RequeteODBC")
req <- connect(req)
req@query
```
