#' Validate that the parameters meet the required schema
#' @param lparams The list of parameters to be validated
#' @export
validate_parameters <- function(params,pschema="pca_projection_schema.json"){
  jsonvalidate::json_validate(params,system.file("extdata",pschema,
                                                 package = "pcaprojection"
  ),verbose=TRUE,error=TRUE)
}

# TODO: create functions to display the required parameters in json structure
# TODO: write a function to extract the json structure from the schema

jsonstruct <- function(jsonschema) {
  rjs <- jsonlite::fromJSON(system.file("extdata",jsonschema,package = "pcaprojection"))

  for (p in rjs) {
    print(str(p))
  }
}
