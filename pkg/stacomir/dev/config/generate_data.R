
if (interactive()) {
	user <- readline(prompt = "Enter user: ")
	password <- readline(prompt = "Enter password: ")
	o <- options()
	options(
			stacomiR.dbname = "bd_contmig_nat",
			stacomiR.host = "localhost",
			stacomiR.port = "5432",
			stacomiR.user = user,
			stacomiR.password = password
	)
}
#################################
# generates a dataset with Durif coefficients
# source Laurent Beaulaton
##################################

coef_durif = matrix(NA, nrow = 5, ncol = 6)
colnames(coef_durif) = c("I", "FII", "FIII", "FIV", "FV", "MII")
rownames(coef_durif) = c("Constant", "BL", "W", "MD", "FL")
coef_durif[, 1] = c(-61.276, 0.242,-0.108, 5.546, 0.614)
coef_durif[, 2] = c(-87.995, 0.286,-0.125, 6.627, 0.838)
coef_durif[, 3] = c(-109.014, 0.280,-0.127, 9.108, 1.182)
coef_durif[, 4] = c(-113.556, 0.218,-0.103, 12.187, 1.230)
coef_durif[, 5] = c(-128.204, 0.242,-0.136, 12.504, 1.821)
coef_durif[, 6] = c(-84.672, 0.176,-0.116, 12.218, 1.295)
usethis::use_data(coef_durif, internal = FALSE, overwrite = TRUE)
#################################
# generates dataset for report_mig_mult
# from iav three dc with eels
##################################


stacomi(TRUE)
r_mig_mult = new("report_mig_mult")

sch <- rlang::env_get(envir_stacomi, "sch") # "iav."
assign("sch", "iav.", envir_stacomi)
r_mig_mult = choice_c(
		r_mig_mult,
		dc = c(5, 6, 12),
		taxa = c("Anguilla anguilla"),
		stage = c("AGG", "AGJ", "CIV"),
		datedebut = "2011-01-01",
		datefin = "2011-12-31"
)
r_mig_mult <- charge(r_mig_mult)
r_mig_mult <- connect(r_mig_mult, silent = FALSE)
# to avoid warnings at package checks
r_mig_mult@dc@data[, "dis_commentaires"] <-
		iconv(r_mig_mult@dc@data[, "dis_commentaires"], from = "latin1", to = "UTF8")
r_mig_mult@dc@data[, "type_df"] <-
		iconv(r_mig_mult@dc@data[, "type_df"], from = "latin1", to = "UTF8")
r_mig_mult@dc@data[, "type_dc"] <-
		iconv(r_mig_mult@dc@data[, "type_dc"], from = "latin1", to = "UTF8")
r_mig_mult@dc@data[, "dif_localisation"] <-
		iconv(r_mig_mult@dc@data[, "dif_localisation"], from = "latin1", to = "UTF8")
r_mig_mult@taxa@data[, "tax_nom_commun"] <-
		iconv(r_mig_mult@taxa@data[, "tax_nom_commun"], from = "latin1", to = "UTF8")
r_mig_mult@stage@data[, "std_libelle"] <-
		iconv(r_mig_mult@stage@data[, "std_libelle"], from = "latin1", to = "UTF8")
r_mig_mult <- calcule(r_mig_mult, silent = FALSE)

usethis::use_data(r_mig_mult, internal = FALSE, overwrite = TRUE)
r_mig_mult_ope <- get("report_ope", envir = envir_stacomi)
r_mig_mult_ope@data$ope_commentaires <-
		iconv(r_mig_mult_ope@data$ope_commentaires,
				from = "latin1",
				to = "UTF8")
r_mig_mult_ope@data$ope_operateur <-
		iconv(r_mig_mult_ope@data$ope_operateur,
				from = "latin1",
				to = "UTF8")
r_mig_mult_ope@dc@data[, "dis_commentaires"] <-
		iconv(r_mig_mult_ope@dc@data[, "dis_commentaires"], from = "latin1", to =
						"UTF8")
r_mig_mult_ope@dc@data[, "type_df"] <-
		iconv(r_mig_mult_ope@dc@data[, "type_df"], from = "latin1", to = "UTF8")
r_mig_mult_ope@dc@data[, "type_dc"] <-
		iconv(r_mig_mult_ope@dc@data[, "type_dc"], from = "latin1", to = "UTF8")
r_mig_mult_ope@dc@data[, "dif_localisation"] <-
		iconv(r_mig_mult_ope@dc@data[, "dif_localisation"], from = "latin1", to =
						"UTF8")
usethis::use_data(r_mig_mult_ope, internal = FALSE, overwrite = TRUE)


r_mig_mult_df <- get("report_df", envir = envir_stacomi)
r_mig_mult_df@df@data[, "dis_commentaires"] <-
		iconv(r_mig_mult_df@df@data[, "dis_commentaires"], from = "latin1", to =
						"UTF8")
r_mig_mult_df@df@data[, "type_df"] <-
		iconv(r_mig_mult_df@df@data[, "type_df"], from = "latin1", to = "UTF8")
#r_mig_mult_df@df@data[,"type_dc"]<-iconv(r_mig_mult_df@df@data[,"type_dc"],from="latin1",to="UTF8")
r_mig_mult_df@df@data[, "dif_localisation"] <-
		iconv(r_mig_mult_df@df@data[, "dif_localisation"], from = "latin1", to =
						"UTF8")
r_mig_mult_df@data$per_commentaires <-
		iconv(r_mig_mult_df@data$per_commentaires,
				from = "latin1",
				to = "UTF8")
usethis::use_data(r_mig_mult_df, internal = FALSE, overwrite = TRUE)


r_mig_mult_dc <- get("report_dc", envir = envir_stacomi)
r_mig_mult_dc@dc@data[, "dis_commentaires"] <-
		iconv(r_mig_mult_dc@dc@data[, "dis_commentaires"], from = "latin1", to =
						"UTF8")
r_mig_mult_dc@dc@data[, "ouv_libelle"] <-
		iconv(r_mig_mult_dc@dc@data[, "ouv_libelle"], from = "latin1", to = "UTF8")
r_mig_mult_dc@dc@data[, "type_dc"] <-
		iconv(r_mig_mult_dc@dc@data[, "type_dc"], from = "latin1", to = "UTF8")
r_mig_mult_dc@dc@data[, "type_df"] <-
		iconv(r_mig_mult_dc@dc@data[, "type_df"], from = "latin1", to = "UTF8")
r_mig_mult_dc@dc@data[, "dif_localisation"] <-
		iconv(r_mig_mult_dc@dc@data[, "dif_localisation"], from = "latin1", to =
						"UTF8")
r_mig_mult_dc@data$per_commentaires <-
		iconv(r_mig_mult_dc@data$per_commentaires,
				from = "latin1",
				to = "UTF8")

usethis::use_data(r_mig_mult_dc, internal = FALSE, overwrite = TRUE)
#################################
# generates dataset for report_mig
# from the vertical slot fishway located at the estuary of the Vilaine (Brittany)
# Taxa Petromyzon Marinus, spawner (stage 11) in 2012
##################################

stacomi(database_expected = TRUE, sch="test")
r_mig = new("report_mig")
o <- options()
options(
		stacomiR.dbname = "bd_contmig_nat_test",
		stacomiR.host = "localhost",
		stacomiR.port = "5432",
		stacomiR.user = user,
		stacomiR.password = password
)
r_mig = choice_c(
		r_mig,
		dc = 5,
		taxa = c("Petromyzon marinus"),
		stage = 11,
		datedebut = "2012-01-01",
		datefin = "2012-12-31"
)
r_mig <- charge(r_mig)
r_mig <- connect(r_mig)

r_mig@dc@data[, "dis_commentaires"] <-
		iconv(r_mig@dc@data[, "dis_commentaires"], from = "latin1", to = "UTF8")
r_mig@dc@data[, "type_df"] <-
		iconv(r_mig@dc@data[, "type_df"], from = "latin1", to = "UTF8")
r_mig@dc@data[, "type_dc"] <-
		iconv(r_mig@dc@data[, "type_dc"], from = "latin1", to = "UTF8")
r_mig@dc@data[, "dif_localisation"] <-
		iconv(r_mig@dc@data[, "dif_localisation"], from = "latin1", to = "UTF8")
r_mig@taxa@data[, "tax_nom_commun"] <-
		iconv(r_mig@taxa@data[, "tax_nom_commun"], from = "latin1", to = "UTF8")
r_mig@stage@data[, "std_libelle"] <-
		iconv(r_mig@stage@data[, "std_libelle"], from = "latin1", to = "UTF8")
r_mig <- calcule(r_mig, silent = TRUE)

usethis::use_data(r_mig, internal = FALSE, overwrite = TRUE)



r_mig_ope <- get("report_ope", envir = envir_stacomi)
r_mig_ope@data$ope_commentaires <-
		iconv(r_mig_ope@data$ope_commentaires,
				from = "latin1",
				to = "UTF8")
r_mig_ope@data$ope_operateur <-
		iconv(r_mig_ope@data$ope_operateur, from = "latin1", to = "UTF8")
r_mig_ope@dc@data[, "dis_commentaires"] <-
		iconv(r_mig_ope@dc@data[, "dis_commentaires"], from = "latin1", to = "UTF8")
r_mig_ope@dc@data[, "type_df"] <-
		iconv(r_mig_ope@dc@data[, "type_df"], from = "latin1", to = "UTF8")
r_mig_ope@dc@data[, "type_dc"] <-
		iconv(r_mig_ope@dc@data[, "type_dc"], from = "latin1", to = "UTF8")
r_mig_ope@dc@data[, "dif_localisation"] <-
		iconv(r_mig_ope@dc@data[, "dif_localisation"], from = "latin1", to = "UTF8")

usethis::use_data(r_mig_ope, internal = FALSE, overwrite = TRUE)


r_mig_df <- get("report_df", envir = envir_stacomi)
r_mig_df@df@data[, "dis_commentaires"] <-
		iconv(r_mig_df@df@data[, "dis_commentaires"], from = "latin1", to = "UTF8")
r_mig_df@df@data[, "type_df"] <-
		iconv(r_mig_df@df@data[, "type_df"], from = "latin1", to = "UTF8")
#r_mig_df@df@data[,"type_dc"]<-iconv(r_mig_df@df@data[,"type_dc"],from="latin1",to="UTF8")
r_mig_df@df@data[, "dif_localisation"] <-
		iconv(r_mig_df@df@data[, "dif_localisation"], from = "latin1", to = "UTF8")
r_mig_df@data$per_commentaires <-
		iconv(r_mig_df@data$per_commentaires,
				from = "latin1",
				to = "UTF8")
usethis::use_data(r_mig_df, internal = FALSE, overwrite = TRUE)

r_mig_dc <- get("report_dc", envir = envir_stacomi)
r_mig_dc@dc@data[, "ouv_libelle"] <-
		iconv(r_mig_dc@dc@data[, "ouv_libelle"], from = "latin1", to = "UTF8")
r_mig_dc@dc@data[, "dis_commentaires"] <-
		iconv(r_mig_dc@dc@data[, "dis_commentaires"], from = "latin1", to = "UTF8")
r_mig_dc@dc@data[, "type_dc"] <-
		iconv(r_mig_dc@dc@data[, "type_dc"], from = "latin1", to = "UTF8")
r_mig_dc@dc@data[, "type_df"] <-
		iconv(r_mig_dc@dc@data[, "type_df"], from = "latin1", to = "UTF8")
r_mig_dc@dc@data[, "dif_localisation"] <-
		iconv(r_mig_dc@dc@data[, "dif_localisation"], from = "latin1", to = "UTF8")
r_mig_dc@data$per_commentaires <-
		iconv(r_mig_dc@data$per_commentaires,
				from = "latin1",
				to = "UTF8")
usethis::use_data(r_mig_dc, internal = FALSE, overwrite = TRUE)

#################################
# generates dataset for report_df
##################################

stacomi(database_expected = TRUE)
r_df = new("report_df")
r_df <- choice_c(
		r_df,
		1,
		horodatedebut = "2015-01-01",
		horodatefin = "2015-12-31",
		silent = TRUE
)
tz <- Sys.timezone()
Sys.setenv(TZ = 'GMT') # there are data when hour shift, without this the graph will fail
r_df <- charge(r_df)
r_df <- connect(r_df)

r_df@df@data[, "dis_commentaires"] <-
		iconv(r_df@df@data[, "dis_commentaires"], from = "latin1", to = "UTF8")
r_df@df@data[, "type_df"] <-
		iconv(r_df@df@data[, "type_df"], from = "latin1", to = "UTF8")
#r_df@df@data[,"type_dc"]<-iconv(r_df@df@data[,"type_dc"],from="latin1",to="UTF8")
r_df@df@data[, "dif_localisation"] <-
		iconv(r_df@df@data[, "dif_localisation"], from = "latin1", to = "UTF8")
r_df@data$per_commentaires <-
		iconv(r_df@data$per_commentaires, from = "latin1", to = "UTF8")
#plot(r_df,plot.type="1")
#plot(r_df,plot.type="2",title="A nice title")

Sys.setenv(TZ = tz)
usethis::use_data(r_df, internal = FALSE, overwrite = TRUE)


#################################
# generates dataset for report_dc
##################################


stacomi(database_expected = TRUE)
r_dc = new("report_dc")
r_dc <- choice_c(
		r_dc,
		5,
		horodatedebut = "2000-01-01",
		horodatefin = "2015-12-31",
		silent = TRUE
)
tz <- Sys.timezone()
Sys.setenv(TZ = 'GMT') # there are data when hour shift, without this the graph will fail
r_dc <- charge(r_dc)
r_dc <- connect(r_dc)
r_dc@dc@data[, "ouv_libelle"] <-
		iconv(r_dc@dc@data[, "ouv_libelle"], from = "latin1", to = "UTF8")
r_dc@dc@data[, "dis_commentaires"] <-
		iconv(r_dc@dc@data[, "dis_commentaires"], from = "latin1", to = "UTF8")
r_dc@dc@data[, "type_df"] <-
		iconv(r_dc@dc@data[, "type_df"], from = "latin1", to = "UTF8")
r_dc@dc@data[, "type_dc"] <-
		iconv(r_dc@dc@data[, "type_dc"], from = "latin1", to = "UTF8")
r_dc@dc@data[, "dif_localisation"] <-
		iconv(r_dc@dc@data[, "dif_localisation"], from = "latin1", to = "UTF8")
r_dc@data$per_commentaires <-
		iconv(r_dc@data$per_commentaires, from = "latin1", to = "UTF8")

usethis::use_data(r_dc, internal = FALSE, overwrite = TRUE)
Sys.setenv(TZ = tz)
#################################
# generates dataset for report_sample_char
##################################


stacomi(database_expected = TRUE)
r_sample_char <- new("report_sample_char")
# the following will load data for size,
# parameters  1786 (total size) and C001 (size at video control)
# are all size measures
# dc 5 and 6 are fishways located on the Arzal dam
# two stages are selected
r_sample_char <- choice_c(
		r_sample_char,
		dc = c(5, 6),
		taxa = c("Anguilla anguilla"),
		stage = c("AGJ", "CIV"),
		par = c(1786, "C001"),
		horodatedebut = "2013-01-01",
		horodatefin = "2013-12-31",
		silent = FALSE
)
# two warning produced, ignored if silent=TRUE
r_sample_char <- connect(r_sample_char)
r_sample_char <- calcule(r_sample_char)

r_sample_char@dc@data[, "ouv_libelle"] <-
		iconv(r_sample_char@dc@data[, "ouv_libelle"], from = "latin1", to = "UTF8")
r_sample_char@dc@data[, "dis_commentaires"] <-
		iconv(r_sample_char@dc@data[, "dis_commentaires"], from = "latin1", to =
						"UTF8")
r_sample_char@dc@data[, "type_df"] <-
		iconv(r_sample_char@dc@data[, "type_df"], from = "latin1", to = "UTF8")
r_sample_char@dc@data[, "type_dc"] <-
		iconv(r_sample_char@dc@data[, "type_dc"], from = "latin1", to = "UTF8")
r_sample_char@dc@data[, "dif_localisation"] <-
		iconv(r_sample_char@dc@data[, "dif_localisation"], from = "latin1", to =
						"UTF8")
r_sample_char@par@data[, "par_nom"] <-
		iconv(r_sample_char@par@data[, "par_nom"], from = "latin1", to = "UTF8")
r_sample_char@data$dev_libelle <-
		iconv(r_sample_char@data$dev_libelle,
				from = "latin1",
				to = "UTF8")
r_sample_char@data$std_libelle <-
		iconv(r_sample_char@data$std_libelle,
				from = "latin1",
				to = "UTF8")
r_sample_char@data$val_libelle <-
		iconv(r_sample_char@data$val_libelle,
				from = "latin1",
				to = "UTF8")
r_sample_char@data$par_nom <-
		iconv(r_sample_char@data$par_nom, from = "latin1", to = "UTF8")
r_sample_char <- calcule(r_sample_char)

usethis::use_data(r_sample_char, internal = FALSE, overwrite = TRUE)

#################################
# generates dataset for report_mig_interannual
# edited 2021 as stage changed in the db (now PANG)
##################################




stacomi(database_expected = TRUE, sch ='pmp')
r_mig_interannual <- new("report_mig_interannual")

r_mig_interannual <- choice_c(
		r_mig_interannual,
		dc = 16,
		taxa = c("Anguilla anguilla"),
		stage = c("PANG"),
		start_year = 1984,
		end_year = 2015,
		silent = FALSE
)
# this will just test that the object is valid... not really a necessary step for this class
#r_mig_interannual<-charge(r_mig_interannual,silent=TRUE)
r_mig_interannual <- connect(r_mig_interannual, silent = FALSE)
r_mig_interannual <- calcule(r_mig_interannual, silent = TRUE)

r_mig_interannual@dc@data[, "ouv_libelle"] <-
		iconv(r_mig_interannual@dc@data[, "ouv_libelle"], from = "latin1", to =
						"UTF8")
r_mig_interannual@dc@data[, "dis_commentaires"] <-
		iconv(r_mig_interannual@dc@data[, "dis_commentaires"], from = "latin1", to =
						"UTF8")
r_mig_interannual@dc@data[, "type_df"] <-
		iconv(r_mig_interannual@dc@data[, "type_df"], from = "latin1", to = "UTF8")
r_mig_interannual@dc@data[, "type_dc"] <-
		iconv(r_mig_interannual@dc@data[, "type_dc"], from = "latin1", to = "UTF8")
r_mig_interannual@dc@data[, "dif_localisation"] <-
		iconv(r_mig_interannual@dc@data[, "dif_localisation"], from = "latin1", to =
						"UTF8")


usethis::use_data(r_mig_interannual, internal = FALSE, overwrite = TRUE)
#################################
# generates dataset for report_annual
##################################


stacomi(database_expected = TRUE)
r_ann <- new("report_annual")
r_ann <- choice_c(
		r_ann,
		dc = c(5, 6, 12),
		taxa = c("Anguilla anguilla"),
		stage = c("AGJ", "AGG"),
		start_year = "1996",
		end_year = "2015",
		silent = FALSE
)
r_ann <- connect(r_ann)
r_ann@dc@data[, "ouv_libelle"] <-
		iconv(r_ann@dc@data[, "ouv_libelle"], from = "latin1", to = "UTF8")
r_ann@dc@data[, "dis_commentaires"] <-
		iconv(r_ann@dc@data[, "dis_commentaires"], from = "latin1", to = "UTF8")
r_ann@dc@data[, "type_df"] <-
		iconv(r_ann@dc@data[, "type_df"], from = "latin1", to = "UTF8")
r_ann@dc@data[, "type_dc"] <-
		iconv(r_ann@dc@data[, "type_dc"], from = "latin1", to = "UTF8")
r_ann@dc@data[, "dif_localisation"] <-
		iconv(r_ann@dc@data[, "dif_localisation"], from = "latin1", to = "UTF8")
r_ann@taxa@data[, "tax_nom_commun"] <-
		iconv(r_ann@taxa@data[, "tax_nom_commun"], from = "latin1", to = "UTF8")
r_ann@stage@data[, "std_libelle"] <-
		iconv(r_ann@stage@data[, "std_libelle"], from = "latin1", to = "UTF8")

usethis::use_data(r_ann, internal = FALSE, overwrite = TRUE)

#################################
# generates dataset for report_annual : migradour
##################################


stacomi(database_expected = TRUE, sch ="migradour")
r_ann_adour <- new("report_annual")
r_ann_adour <- choice_c(
		r_ann_adour,
		dc = c(33:40),
		taxa = c("Salmo salar"),
		stage = c(11),
		start_year = "1996",
		end_year = "2015",
		silent = FALSE
)
r_ann_adour <- connect(r_ann_adour)
r_ann_adour@dc@data[, "ouv_libelle"] <-
		iconv(r_ann_adour@dc@data[, "ouv_libelle"], from = "latin1", to = "UTF8")
r_ann_adour@dc@data[, "dis_commentaires"] <-
		iconv(r_ann_adour@dc@data[, "dis_commentaires"], from = "latin1", to = "UTF8")
r_ann_adour@dc@data[, "type_df"] <-
		iconv(r_ann_adour@dc@data[, "type_df"], from = "latin1", to = "UTF8")
r_ann_adour@dc@data[, "type_dc"] <-
		iconv(r_ann_adour@dc@data[, "type_dc"], from = "latin1", to = "UTF8")
r_ann_adour@dc@data[, "dc_code"] <-
		iconv(r_ann_adour@dc@data[, "dc_code"], from = "latin1", to = "UTF8")
r_ann_adour@dc@data[, "dif_localisation"] <-
		iconv(r_ann_adour@dc@data[, "dif_localisation"], from = "latin1", to = "UTF8")
r_ann_adour@taxa@data[, "tax_nom_commun"] <-
		iconv(r_ann_adour@taxa@data[, "tax_nom_commun"], from = "latin1", to = "UTF8")
r_ann_adour@stage@data[, "std_libelle"] <-
		iconv(r_ann_adour@stage@data[, "std_libelle"], from = "latin1", to = "UTF8")

usethis::use_data(r_ann_adour, internal = FALSE, overwrite = TRUE)



#################################
# generates dataset for reportsilver : fd80 the somme
##################################

stacomi(database_expected = TRUE, sch ="fd80")
r_silver <- new("report_silver_eel")
r_silver <- choice_c(
		r_silver,
		dc = c(2, 6),
		horodatedebut = "2010-09-01",
		horodatefin = "2016-10-04",
		silent = FALSE
)
# two warning produced, ignored if silent=TRUE
r_silver <- connect(r_silver)
r_silver@dc@data[, "ouv_libelle"] <-
		iconv(r_silver@dc@data[, "ouv_libelle"], from = "latin1", to = "UTF8")
r_silver@dc@data[, "dis_commentaires"] <-
		iconv(r_silver@dc@data[, "dis_commentaires"], from = "latin1", to = "UTF8")
r_silver@dc@data[, "type_df"] <-
		iconv(r_silver@dc@data[, "type_df"], from = "latin1", to = "UTF8")
r_silver@dc@data[, "type_dc"] <-
		iconv(r_silver@dc@data[, "type_dc"], from = "latin1", to = "UTF8")
r_silver@dc@data[, "dif_localisation"] <-
		iconv(r_silver@dc@data[, "dif_localisation"], from = "latin1", to = "UTF8")
r_silver@taxa@data[, "tax_nom_commun"] <-
		iconv(r_silver@taxa@data[, "tax_nom_commun"], from = "latin1", to = "UTF8")
r_silver@stage@data[, "std_libelle"] <-
		iconv(r_silver@stage@data[, "std_libelle"], from = "latin1", to = "UTF8")
r_silver@par@data[, "par_nom"] <-
		iconv(r_silver@par@data[, "par_nom"], from = "latin1", to = "UTF8")
r_silver@data$dev_libelle <-
		iconv(r_silver@data$dev_libelle, from = "latin1", to = "UTF8")
r_silver@data$std_libelle <-
		iconv(r_silver@data$std_libelle, from = "latin1", to = "UTF8")
r_silver@data$val_libelle <-
		iconv(r_silver@data$val_libelle, from = "latin1", to = "UTF8")
r_silver@data$par_nom <-
		iconv(r_silver@data$par_nom, from = "latin1", to = "UTF8")

usethis::use_data(r_silver, internal = FALSE, overwrite = TRUE)

#################################
# generates dataset for report_ge_weight : iav
##################################

Sys.setenv(LANG = "EN")
stacomi(database_expected = TRUE)
r_gew <- new("report_ge_weight")
r_gew@liste <-
		charge(
				object = r_gew@liste,
				listechoice = c("=1", ">1", "tous"),
				label = ""
		)
r_gew <- choice_c(
		r_gew,
		dc = c(6),
		start_year = "2009",
		end_year = "2016",
		selectedvalue = ">1",
		silent = FALSE
)
r_gew <- connect(r_gew)
r_gew@dc@data[, "ouv_libelle"] <-
		iconv(r_gew@dc@data[, "ouv_libelle"], from = "latin1", to = "UTF8")
r_gew@dc@data[, "dis_commentaires"] <-
		iconv(r_gew@dc@data[, "dis_commentaires"], from = "latin1", to = "UTF8")
r_gew@dc@data[, "type_df"] <-
		iconv(r_gew@dc@data[, "type_df"], from = "latin1", to = "UTF8")
r_gew@dc@data[, "type_dc"] <-
		iconv(r_gew@dc@data[, "type_dc"], from = "latin1", to = "UTF8")
r_gew@dc@data[, "dif_localisation"] <-
		iconv(r_gew@dc@data[, "dif_localisation"], from = "latin1", to = "UTF8")
r_gew <- calcule(r_gew)
usethis::use_data(r_gew, internal = FALSE, overwrite = TRUE)


#################################
# generates dataset for report_sea_age r_seaa
#TODO voir avec Marion pourquoi ça charge pas ????
##################################


stacomi(database_expected = TRUE, sch="logrami")
#o <- options()
#
#options(
#		stacomiR.dbname = "bd_contmig_nat",
#		stacomiR.host = readline(prompt = "Enter host: "),
#		stacomiR.port = "5432",
#		stacomiR.user = readline(prompt = "Enter user: "),
#		stacomiR.password = readline(prompt = "Enter password: ")
#)
r_seaa <- new("report_sea_age")

r_seaa <- choice_c(
		r_seaa,
		dc = c(107, 108, 101),
		horodatedebut = "2012-01-01",
		horodatefin = "2012-12-31",
		limit1hm = 675,
		limit2hm = 875,
		silent = FALSE
)
r_seaa <- connect(r_seaa)
r_seaa@dc@data[, "ouv_libelle"] <-
		iconv(r_seaa@dc@data[, "ouv_libelle"], from = "latin1", to = "UTF8")
r_seaa@dc@data[, "dis_commentaires"] <-
		iconv(r_seaa@dc@data[, "dis_commentaires"], from = "latin1", to = "UTF8")
r_seaa@dc@data[, "type_df"] <-
		iconv(r_seaa@dc@data[, "type_df"], from = "latin1", to = "UTF8")
r_seaa@dc@data[, "type_dc"] <-
		iconv(r_seaa@dc@data[, "type_dc"], from = "latin1", to = "UTF8")
r_seaa@dc@data[, "dif_localisation"] <-
		iconv(r_seaa@dc@data[, "dif_localisation"], from = "latin1", to = "UTF8")
r_seaa@data[, "car_valeur_quantitatif"] <-
		r_seaa@data[, "car_valeur_quantitatif"] * 10
r_seaa@data[, "par_nom"] <-
		iconv(r_seaa@data[, "par_nom"], from = "latin1", to = "UTF8")
r_seaa@data[, "dev_libelle"] <-
		iconv(r_seaa@data[, "dev_libelle"], from = "latin1", to = "UTF8")
r_seaa@data[, "std_libelle"] <-
		iconv(r_seaa@data[, "std_libelle"], from = "latin1", to = "UTF8")
r_seaa@taxa@data[, "tax_nom_commun"] <-
		iconv(r_seaa@taxa@data[, "tax_nom_commun"], from = "latin1", to = "UTF8")
r_seaa@par@data[, "par_nom"] <-
		iconv(r_seaa@par@data[, "par_nom"], from = "latin1", to = "UTF8")
r_seaa@stage@data[, "std_libelle"] <-
		iconv(r_seaa@stage@data[, "std_libelle"], from = "latin1", to = "UTF8")
r_seaa@data$car_valeur_quantitatif[r_seaa@data$car_par_code == "C001"] <-
		r_seaa@data$car_valeur_quantitatif[r_seaa@data$car_par_code == "C001"] /
		10
r_seaa <- calcule(r_seaa)
usethis::use_data(r_seaa, internal = FALSE, overwrite = TRUE)


#################################
# generates dataset for report_mig_interannual with two dc
##################################
stacomi(database_expected = TRUE, sch="logrami")
r_mig_interannual_vichy <- new("report_mig_interannual")


r_mig_interannual_vichy <- choice_c(
		r_mig_interannual_vichy,
		dc = c(107),
		taxa = c("Salmo salar"),
		stage = c("5"),
		start_year = "1997",
		end_year = "2012",
		silent = FALSE
)
#r_mig_interannual_vichy<-charge(r_mig_interannual_vichy)
r_mig_interannual_vichy <- connect(r_mig_interannual_vichy)
r_mig_interannual_vichy@dc@data[, "ouv_libelle"] <-
		iconv(r_mig_interannual_vichy@dc@data[, "ouv_libelle"],
				from = "latin1",
				to = "UTF8")
r_mig_interannual_vichy@dc@data[, "dis_commentaires"] <-
		iconv(r_mig_interannual_vichy@dc@data[, "dis_commentaires"],
				from = "latin1",
				to = "UTF8")
r_mig_interannual_vichy@dc@data[, "type_df"] <-
		iconv(r_mig_interannual_vichy@dc@data[, "type_df"],
				from = "latin1",
				to = "UTF8")
r_mig_interannual_vichy@dc@data[, "type_dc"] <-
		iconv(r_mig_interannual_vichy@dc@data[, "type_dc"],
				from = "latin1",
				to = "UTF8")
r_mig_interannual_vichy@dc@data[, "dif_localisation"] <-
		iconv(r_mig_interannual_vichy@dc@data[, "dif_localisation"],
				from = "latin1",
				to = "UTF8")
usethis::use_data(r_mig_interannual_vichy,
		internal = FALSE,
		overwrite = TRUE)

#################################
# generates dataset for report_env
##################################

stacomi(database_expected = TRUE)
r_env <- new("report_env")
r_env <- choice_c(
		r_env,
		stationMesure = c("temp_gabion", "coef_maree"),
		datedebut = "2008-01-01",
		datefin = "2008-12-31",
		silent = FALSE
)
r_env <- connect(r_env)
r_env@stationMesure@data$stm_description <-
		iconv(r_env@stationMesure@data$stm_description,
				from = "latin1",
				to = "UTF8")
usethis::use_data(r_env, internal = FALSE, overwrite = TRUE)

#################################
# generates dataset for report_mig_char
##################################

stacomi(database_expected = TRUE, sch = "logrami")
r_mig_char <- new("report_mig_char")

# here parqual is not in the list
# so this is equivalent to parqual=NULL
r_mig_char <- choice_c(
		r_mig_char,
		dc = c(107, 108, 101),
		taxa = c("Salmo salar"),
		stage = c('5', '11', 'BEC', 'BER', 'IND'),
		parquan = c('C001', '1786', '1785'),
		horodatedebut = "2012-01-01",
		horodatefin = "2012-12-31",
		silent = FALSE
)
# r_mig_char<-charge(r_mig_char) not necessary there
r_mig_char <- connect(r_mig_char)
r_mig_char@dc@data[, "ouv_libelle"] <-
		iconv(r_mig_char@dc@data[, "ouv_libelle"], from = "latin1", to = "UTF8")
r_mig_char@dc@data[, "dis_commentaires"] <-
		iconv(r_mig_char@dc@data[, "dis_commentaires"], from = "latin1", to = "UTF8")
r_mig_char@dc@data[, "type_df"] <-
		iconv(r_mig_char@dc@data[, "type_df"], from = "latin1", to = "UTF8")
r_mig_char@dc@data[, "type_dc"] <-
		iconv(r_mig_char@dc@data[, "type_dc"], from = "latin1", to = "UTF8")
r_mig_char@dc@data[, "dif_localisation"] <-
		iconv(r_mig_char@dc@data[, "dif_localisation"], from = "latin1", to = "UTF8")
usethis::use_data(r_mig_char, internal = FALSE, overwrite = TRUE)


#################################
# generates dataset for report_mig_env
##################################

stacomi(database_expected = TRUE)

r_mig_env <- new("report_mig_env")
r_mig_env <- choice_c(
		r_mig_env,
		dc = c(5, 6, 12),
		taxa = c("Anguilla anguilla"),
		stage = c("AGJ", "AGG", "CIV"),
		stationMesure = c("temp_gabion", "coef_maree", "phases_lune"),
		datedebut = "2008-01-01",
		datefin = "2008-12-31",
		silent = FALSE
)
r_mig_env <- charge(r_mig_env)
r_mig_env <- connect(r_mig_env)
r_mig_env <- calcule(r_mig_env, silent = TRUE)

r_mig_env@report_mig_mult@dc@data[, "ouv_libelle"] <-
		iconv(r_mig_env@report_mig_mult@dc@data[, "ouv_libelle"],
				from = "latin1",
				to = "UTF8")
r_mig_env@report_mig_mult@dc@data[, "dis_commentaires"] <-
		iconv(r_mig_env@report_mig_mult@dc@data[, "dis_commentaires"],
				from = "latin1",
				to = "UTF8")
r_mig_env@report_mig_mult@dc@data[, "type_df"] <-
		iconv(r_mig_env@report_mig_mult@dc@data[, "type_df"],
				from = "latin1",
				to = "UTF8")
r_mig_env@report_mig_mult@dc@data[, "type_dc"] <-
		iconv(r_mig_env@report_mig_mult@dc@data[, "type_dc"],
				from = "latin1",
				to = "UTF8")
r_mig_env@report_mig_mult@dc@data[, "dif_localisation"] <-
		iconv(r_mig_env@report_mig_mult@dc@data[, "dif_localisation"],
				from = "latin1",
				to = "UTF8")
r_mig_env@report_env@stationMesure@data$stm_description <-
		iconv(
				r_mig_env@report_env@stationMesure@data$stm_description,
				from = "latin1",
				to = "UTF8"
		)
r_mig_env@report_mig_mult@stage@data[, "std_libelle"] <-
		iconv(r_mig_env@report_mig_mult@stage@data[, "std_libelle"],
				from = "latin1",
				to = "UTF8")

usethis::use_data(r_mig_env, internal = FALSE, overwrite = TRUE)
