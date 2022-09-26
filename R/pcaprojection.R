
#' Validate that the parameters meet the required schema
#' @param lparams The list of parameters to be validated
#' @export
validate_parameters <- function(params,pschema="pca_projection_schema.json"){
  jsonvalidate::json_validate(params,system.file("extdata",pschema,
                                                 package = "pcaprojection"
                                                 ),verbose=TRUE,error=TRUE)
}

#' Projection based on principal component analysis
#'
pcaproj <- function(parametersfile){

  if (file.exists(parametersfile)){
    tryCatch(lp <-  jsonlite::fromJSON(parametersfile),
             error = function(c) {
               c$message <- paste0(c$message, " (in ", parametersfile, ")")
               stop(c)
             }
    )
  } else {
      message <- paste0("Parameter file '", parametersfile, "' not found.")
      stop(message)
  }

  res <- validate_parameters(parametersfile)

  if (res==FALSE) {
    stop("The json parameters file does not meet the schema")
  }

  print("Print creating the PCA projection ...")
  colorear <- lp$colour

  if (colorear == ""){
    colorear = NULL
  }

  pscale <- lp$scale
  pbiplot <- lp$biplot
  pcacols <- lp$col_ids

  tryCatch(cols <- data.table::fread(lp$filename,select = pcacols),
           error = function(c) {
             c$message <- paste0(c$message, " (in ", parametersfile, ")")
             stop(c)
           }
  )

  print(str(cols))
  pcacols <- pcacols[! pcacols %in% append(c(),colorear)]

  print(pcacols)
  # PCA
  tpca <- stats::prcomp(Filter(is.numeric,dplyr::select(cols,pcacols)),scale=pscale)
  # TODO: investigate namespace for print(summary(tpca))
  print(summary(tpca))
  # load `.__T__[:base` to fix `! Objects of type prcomp not supported by autoplot.`
  ggfortify::`.__T__[:base`
  p <- ggplot2::autoplot(tpca, data = cols, colour = colorear,
                         loadings = pbiplot, loadings.colour = 'black',
                         loadings.label = pbiplot,
                         loadings.label.colour = 'black',
                         loadings.label.size = 4) + ggplot2::theme_bw()
  p <- p + ggplot2::labs(title = lp$title,caption = lp$caption)
  p <- p + ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
  if (lp$save==TRUE){
    now <- Sys.time()
    outputfile <- file.path(paste0(lp$filename,"-pca-",format(now, "%Y%m%d_%H%M%S"),".",lp$device))
    ggplot2::ggsave(outputfile,plot=p, device= lp$device,  width = lp$width,
                    height =lp$height, units = "cm")
    print(paste("Projection saved in: ",outputfile))
    if (lp$interactive == TRUE) {
      print("Creating interactive plot")
      ip <- plotly::ggplotly(p)
      htmlwidgets::saveWidget(ip, "../test.html")
    }
  }
}



wide2long <- function(parametersfile){
  if (file.exists(parametersfile)){
    tryCatch(lp <- jsonlite::fromJSON(parametersfile),
             error = function(c) {
               c$message <- paste0(c$message, " (in ", parametersfile, ")")
               stop(c)
             }
    )
  } else {
    message <- paste0("Parameter file '", parametersfile, "' not found.")
    stop(message)
  }

  print(lp)

  res <- validate_parameters(parametersfile,pschema = "wide2long_schema.json")

  if (res==FALSE) {
    stop("The json parameters file does not meet the schema")
  }

  print(lp$col_ids)
  print(length(lp$col_ids))

  if (!length(lp$col_ids) > 0){
    lp$col_ids <- NULL
  }

  tryCatch(cols <- data.table::fread(lp$filename,select = lp$col_ids),
           error = function(c) {
             c$message <- paste0(c$message, " (in ", parametersfile, ")")
             stop(c)
           }
  )

  print(str(cols))

  DT = data.table::melt(cols, id.vars = lp$idvars,measure.vars = lp$measure.vars)
  print(DT)

  if (lp$save == TRUE) {
    print("Saving file ...")
    now <- Sys.time()
    outputfile <- file.path(paste0(lp$filename,"-long-",
                                   format(now, "%Y%m%d_%H%M%S"),".csv"))
    data.table::fwrite(DT,outputfile)
    print(paste("Projection saved in: ",outputfile))
  }
}

# TODO: create functions to display the required parameters in json structure
# TODO: write a function to extract the json structure from the schema

jsonstruct <- function(jsonschema) {
  rjs <- jsonlite::fromJSON(system.file("extdata",jsonschema,package = "pcaprojection"))

  for (p in rjs) {
    print(str(p))
  }
}

