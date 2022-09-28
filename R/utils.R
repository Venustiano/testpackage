#' Validate that the parameters meet the required schema
#'
#' @param lparams The list of parameters to be validated
#' @export
validate_parameters <- function(params,pschema="pca_projection_schema.json"){
  jsonvalidate::json_validate(params,system.file("extdata",pschema,
                                                 package = "pcaprojection"
  ),verbose=TRUE,error=TRUE)
}

#' Title
#' Reads columns from a data table
#'
#' Additional info
#' @param filename a string filename including the relative
#' @param select_columns a vector including the column names from the data file
#'
#' @return if succeds, this function returns a data table
#' @export
#'
# #' @examples
read_data <- function(filename,select_columns){
  tryCatch(cols <- data.table::fread(filename,select = select_columns),
           error = function(c) {
             c$message <- paste0(c$message, " (in ", parametersfile, ")")
             stop(c)
           }
  )
  cols
}


# TODO: create functions to display the required parameters in json structure
# TODO: write a function to extract the json structure from the schema

jsonstruct <- function(jsonschema) {
  rjs <- jsonlite::fromJSON(system.file("extdata",jsonschema,package = "pcaprojection"))

  for (p in rjs) {
    print(str(p))
  }
}
