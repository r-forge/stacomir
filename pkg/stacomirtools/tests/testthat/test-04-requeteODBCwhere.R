context("RequeteODBCwhere")

test_that("Test that RequeteODBCwhere returns rows", {
			skip_on_cran()
			env_set_test_stacomi()
			# this requires an odbc link to be setup for test here a database bd_contmig_nat used for stacomir
			# the odbc link is bd_contmig_nat and points to database bd_contmig_nat
			# userlocal and passwordlocal are generated from Rprofile.site
			object <-new("RequeteODBCwhere")
			object@select<- "select * from iav.t_lot_lot"
			object@where <- "WHERE lot_tax_code='2038'"
			object@and<-c("AND lot_std_code='CIV'","AND lot_ope_identifiant<1000")
			object@order_by<-"ORDER BY lot_identifiant limit 10"
			object@baseODBC=c("bd_contmig_nat", user, password )
			suppressWarnings(object <- connect(object))
			expect_gt(nrow(object@query),0)
		})



