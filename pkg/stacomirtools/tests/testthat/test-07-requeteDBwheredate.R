context("RequeteDBwheredate")

test_that("Test that RequeteDBwheredate works on a database ", {
			skip_on_cran()
			env_set_test_stacomi()
			object <-new("RequeteDBwheredate")
			base=c("bd_contmig_nat",host,"5432",user, password)
			object@datedebut <- strptime("2012-01-01 00:00:00", format="%Y-%m-%d %H:%M:%S")
			object@datefin <-  strptime("2013-01-01 00:00:00", format="%Y-%m-%d %H:%M:%S")
			object@colonnedebut="ope_date_debut" 
			object@colonnefin="ope_date_fin"	
			object@select<- "select * from iav.t_operation_ope JOIN iav.t_lot_lot on lot_ope_identifiant=ope_identifiant"
			object@where <- "WHERE lot_tax_code='2038'"
			object@and<-c("AND lot_std_code='CIV'")
			object@order_by<-"ORDER BY lot_identifiant limit 10"
			object <- query(object, base)
			expect_gt(nrow(object@query),0)
		})





