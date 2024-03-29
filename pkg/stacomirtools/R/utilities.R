#' function used to print the html tables of output (see xtable documentation)
#' 
#' see \pkg{xtable} for further description, an xtable is created and printed
#' to html format
#' 
#' 
#' @param data a data frame
#' @param caption the caption
#' @param top a logical, if true the caption is placed on top
#' @param outfile the path to the file
#' @param clipboard if clipboard TRUE, a copy to the clipboard is made
#' @param append is the file appended to the previous one ?
#' @param digits the number of digits
#' @param ...  additional parameters to be passed to the function
#' @return an xtable
#' @author Cedric Briand \email{cedric.briand@eptb-vilaine.fr}
#' @export
funhtml=function(data,caption=NULL,top=TRUE,outfile=NULL,clipboard=FALSE,append=TRUE,digits=NULL,...){
	
	xt=xtable::xtable(data, caption=caption,digits=digits)
	xt=print(xt,type="html",caption.placement="top",file=outfile)
	# pour changer le defaut "bottom" des caption
	if (clipboard) utils::writeClipboard(xt) 
} 
###########################################
# special functions (exported as they are usefull)
#############################################




#' This function replaces the variable names in a data.frame
#' 
#' This function replaces the variable names in a data.frame
#' 
#' 
#' @param object a data frame
#' @param old_variable_name a character vector with old variables names
#' @param new_variable_name a character vector with new variables names
#' @return object
#' @author Cedric Briand \email{cedric.briand@eptb-vilaine.fr}
#' @examples
#' 
#' df <- data.frame("var1" = c("blue","red"), "var2" = c("nice","ugly"))
#' colnames(df) # "var1" "var2"
#' df <- chnames(object = df, old_variable_name = c("var1","var2"), 
#' "new_variable_name" = c("color","beauty"))
#' colnames(df) # "color"  "beauty"
#' # the following will return an error, as the variable wrong_name is not in variable names
#' \dontrun{
#' chnames(object = df, old_variable_name = c("wrong_name"), 
#' "new_variable_name" = c("color")))
#' }
#' 
#' @export
chnames=function(object,
		old_variable_name,
		new_variable_name){
	if (length(old_variable_name)!=length(new_variable_name)) stop("les variables de remplacement doivent avoir le meme nombre que les variables de depart")
	if (!all(!is.na(match(old_variable_name,colnames(object))))) {
		stop(paste("les noms",paste(is.na(match(old_variable_name,colnames(object))),collapse="/"),"ne correspondent pas aux variables du tableau"))
	}
	colnames(object)[match(old_variable_name,colnames(object))]<- new_variable_name
	return(object)
}






#' unique values of a vector
#' 
#' returns the index of values appearing only once in a vector :
#' match(unique(a),a), replicated values are not returned on their second
#' occurence
#' 
#' 
#' @param a a vector
#' @return the index unique values within a vector
#' @author Cedric Briand \email{cedric.briand@eptb-vilaine.fr}
#' @examples
#' 
#' induk(c(1,1,2,2,2,3))
#' 
#' @export
induk=function(a){
	sol=match(unique(a),a)     #index des valeurs uniques
	return(sol)   
}


#' very usefull function used to "kill" the factors, noticeably after loading with 'ODBC'
#' 
#' @param df a data.frame
#' @return df
#' @author Cedric Briand \email{cedric.briand@eptb-vilaine.fr}
#' @export
killfactor=function(df){
	for (i in 1:ncol(df))
	{
		if(is.factor(df[,i])) df[,i]=as.character(df[,i])
	}
	return(df)
}





#' ex fonction to write to the clipboard
#' 
#' ex fonction to write to the clipboard
#' 
#' 
#' @param d a dataframe
#' @author Cedric Briand \email{cedric.briand@eptb-vilaine.fr}
#' @export
ex<-function(d=NULL){
	if (is.null(d)){
		xl=utils::select.list(choices=ls(envir=globalenv()), preselect = NULL, multiple = FALSE, title = "choisir l'object")
		utils::write.table(get(xl),"clipboard",sep="\t",col.names=NA)
	} else {
		utils::write.table(d,"clipboard",sep="\t",col.names=NA)
	}
}







#' id.odd function modified from package sma
#' 
#' id.odd function modified from package sma (which did not verify that the
#' entry was indeed an integer)
#' 
#' 
#' @param x integer
#' @return a logical
#' @author Adapted from Henrik Bengtsson
#' @examples
#' 
#' is.odd(1)
#' is.odd(2)
#' 
#' @export
is.odd=function (x) 
{
	if (x==as.integer(x)) {
		if (x%%2 == 0) {
			return(FALSE)
		}
		else {
			return(TRUE)
		}
	}
	else {
		stop("is.odd should be used with an integer")
	}
}




#' is.even function modified from package sma
#' 
#' is.even function modified from package sma (which did not verify that the
#' entry was indeed an integer)
#' 
#' 
#' @param x integer
#' @return a logical
#' @author Adapted from Henrik Bengtsson
#' @examples
#' 
#' is.even(1)
#' is.even(2)
#' 
#' @export
is.even=function (x) 
{
	if (x==as.integer(x)) {
		if (x%%2 != 0) {
			return(FALSE)
		}
		else {
			return(TRUE)
		}
	}
	else {
		stop("is.even should be used with an integer")
	}
}





#' Function to transform a ftable into dataframe but just keeping the counts,
#' works with ftable of dim 2
#' 
#' Function to transform a ftable into dataframe but just keeping the counts
#' works with ftable of dim 2
#' 
#' 
#' @param tab a flat table
#' @author Cedric Briand \email{cedric.briand@eptb-vilaine.fr}
#' @examples
#' 
#' df <- data.frame("var1" = c("blue","red"), "var2" = c("nice","ugly"))
#' ftdf <- ftable(df)
#' tab2df(ftdf)
#' 
#' @export
tab2df <- function(tab){
	if (length((attributes(tab)$dim))>2) stop("only works with tables of dim 2")
	df=as.data.frame(matrix(as.vector(tab),nrow(tab),ncol(tab)))
	rownames(df)<-attributes(tab)$row.vars[[1]]
	colnames(df)<-attributes(tab)$col.vars[[1]]	
	return(df)
}


