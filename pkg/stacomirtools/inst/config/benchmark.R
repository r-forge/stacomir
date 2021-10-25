


devtools::install_github("olafmersmann/microbenchmarkCore")
devtools::install_github("olafmersmann/microbenchmark")

library(microbenchmark)

pool <- function(){
object <-new("RequeteDB")
object@sql <- "select * from iav.t_lot_lot limit 10"
object@dbname <- "bd_contmig_nat"
object@host <- 		"localhost"
object@port <-		"5432"
object@user <-		"postgres"
object@password <-		"postgres"
object <- query(object)
}


odbc <- function(){
	object <-new("RequeteODBC")
	object@baseODBC=c("bd_contmig_nat","postgres","postgres")
	object@sql <- "select * from iav.t_lot_lot limit 10"
	object <- connect(object)
}

mbm <- microbenchmark(pool(),odbc(), times=50)

mbm

library(ggplot2)
autoplot(mbm)