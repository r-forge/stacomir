context("RequeteDBwhere")

test_that("Test that RequeteDBwhere returns rows", {
			skip_on_cran()
			env_set_test_stacomi()
			object <-new("RequeteDBwhere")
			base=c("bd_contmig_nat",host,"5432",user, password)
			object@select<- "select * from iav.t_lot_lot"
			object@where <- "WHERE lot_tax_code='2038'"
			object@and<-c("AND lot_std_code='CIV'")
			object@order_by<-"ORDER BY lot_identifiant limit 10"
			suppressWarnings(object <- query(object, base))
			expect_gt(nrow(object@query),0)
		})
