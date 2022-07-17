# stacomirtools 0.6.0.1

minor fix following CRAN message 15/02, replaced names for author cedric.briand"at" with cedric.briand@ in manual
fixes note due to class() 
changed tests to include helper and avoid  prompt for user and password when testing

# stacomirtools 0.6.0

stacomiR based on gwidget was dropped from CRAN in May 2020, it will soon switch to only command line interface (reprogrammed to remove all dependence to gwidget) and the graphical interface will be a new shiny package.
So basically we need to add connection class that work in LINUX in stacomirtools.

* Rewrote classes for connections using DBI and pool.
* The connection setting can now be made using options.
* Added unit tests to all classes.
* Added documentation using Roxygen.
* Connector classes using RODBC are now marked as deprecated and will fire a warning.

# stacomitools 0.5.3

* added unit tests
* removed bug, file not working when envir_stacomi not present, this environment is added when used with stacomir package.

# stacomitools 0.5.2

* previous version of the package