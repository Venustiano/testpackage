list_params <- function(fileparams,jsonschema){
  # reading list of parameters lp
  lp <- validate_json_file(fileparams)
  res <- validate_parameters(fileparams,pschema=jsonschema)
  return(lp)
}

ggplotplot <- function(list_params) {

}
