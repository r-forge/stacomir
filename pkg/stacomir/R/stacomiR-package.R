#' @import stringr
#' @import RColorBrewer
#' @import ggplot2
#' @import RPostgreSQL
#' @import methods
#' @import stacomirtools
#' @import xtable
#' @importFrom magrittr %>%
#' @importFrom dplyr select
#' @importFrom dplyr group_by
#' @importFrom dplyr summarize
#' @importFrom dplyr rename
#' @importFrom dplyr do
#' @importFrom dplyr filter
#' @importFrom dplyr mutate 
#' @importFrom dplyr min_rank 
#' @importFrom dplyr first
#' @importFrom dplyr ungroup
#' @importFrom dplyr desc
#' @importFrom intervals Intervals
#' @importFrom intervals closed<-
#' @importFrom intervals interval_overlap
#' @importFrom grid viewport
#' @importFrom grid pushViewport
#' @importFrom grid grid.newpage
#' @importFrom grid grid.layout
#' @importFrom utils read.csv
#' @importFrom utils stack
#' @importFrom utils globalVariables
#' @importFrom utils select.list write.table data
#' @importFrom utils txtProgressBar
#' @importFrom stats ftable
#' @importFrom stats xtabs
#' @importFrom stats AIC
#' @importFrom grDevices dev.new
#' @importFrom grDevices gray.colors
#' @importFrom stats sd
#' @importFrom stats complete.cases
#' @importFrom reshape2 dcast
#' @importFrom reshape2 melt
#' @importFrom lattice barchart trellis.par.get trellis.par.set simpleKey
#' @importFrom grid gpar
#' @importFrom graphics layout matplot mtext points polygon segments par axis text legend rect axis.Date abline arrows hist
#' @importFrom stats as.formula coef na.fail nls pbeta predict sd coefficients
#' @importFrom grDevices gray rainbow adjustcolor
#' @importFrom lubridate round_date
#' @importFrom lubridate floor_date
#' @importFrom lubridate %m+%
#' @importFrom lubridate isoweek
#' @importFrom lubridate years
#' @importFrom Hmisc wtd.quantile 
#' @importFrom Hmisc capitalize 
#' @importFrom mgcv gam
#' @importFrom pool poolClose
#' @importFrom pool dbExecute
#' @importFrom pool dbWriteTable
#' @importFrom pool dbGetQuery
NULL

# Variables used in aes arguments generate a note as being assigned to
# .GlobalEnv, either use aes_string, or listing them below removes the warning
# in Rcheck.
utils::globalVariables(c("quinzaine", "mois", "val_quant", "time.sequence", "Effectifs",
				"..density..", "Cumsum", "Date", "Effectif", "Effectif_total", "annee", "car_val_identifiant",
				"car_valeur_quantitatif", "coef", "date_format", "debut_pas", "effectif", "effectif_CALCULE",
				"effectif_EXPERT", "effectif_MESURE", "effectif_PONCTUEL", "effectif_total",
				"report_df", "quantite_CALCULE", "quantite_EXPERT", "quantite_MESURE", "quantite_PONCTUEL",
				"libelle", "null", "type", "val_libelle", "lot_effectif", "lot_identifiant",
				"ope_dic_identifiant", "ope_identifiant", "dev_code", "dev_libelle", "ope_date_fin",
				"report_stage_pigm", "ope_date_debut", "p", "g", "poids_moyen", "taxa_stage",
				"jour", "valeur", "mintab", "maxtab", "moyenne", "jour", "total_annuel", "taxa_stage",
				"time.sequence", "sum", "variable", "duree", "Hdeb", "Hfin", "per_tar_code",
				"per_etat_fonctionnement", "std_libelle", "sumduree", "dc", "stage", "taxa",
				"stage", "ouv", "Q0", "Q100", "Q5", "Q50", "Q95", "age", "bjo_annee", "bjo_labelquantite",
				"bjo_valeur", "doy", "pred_weight", "pred_weight_lwr", "pred_weight_upr", "total",
				"w", "year", "sta", "tableauCEst", "stm_libelle", "env_valeur_quantitatif", "env_val_identifiant",
				"DC", "color", "id"))

# variable used by dplyr
utils::globalVariables(c("n0", "newid", "xmin", "xmax", "fin_pas", "value", "type_de_quantite",
				"lot_tax_code", "lot_std_code", "lot_methode_obtention", "no.pas"))

# dataset used in the package
utils::globalVariables(c("coef_durif"))
# Assignation in global environment for the use of gWidget interface (there is
# no way arround this)
# utils::globalVariables(c('win','group','nbligne','ggrouptotal','ggrouptotal1','gSortie',
#     'col.sortie','ggroupboutons','ggroupboutonsbas','groupdate','groupdc',
#     'frame_annee','frame_check','frame_choice','frame_par','frame_parqual','frame_parquan',
#     'frame_std','frame_tax','frame_annee','frame_check','frame_choice','ref_year',
#     'logw','report_stage_pigm','usrname','usrpwd','notebook','values','ind'))
# Progressbar utils::globalVariables(c('progres')) environment
# utils::globalVariables(c('envir_stacomi')) reoxygenize fails if data are not
# loaded setwd('F:/workspace/stacomir/branch0.5/stacomir')
