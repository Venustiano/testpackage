
#' Validate that the parameters meet the required schema
#' @param lparams The list of parameters to be validated
#' @export
validate_parameters <- function(lparams){
  v <- jsonvalidate::json_validator(system.file("extdata","pca_projection_schema.json",package = "pcaprojection"))
  v(jsonlite::toJSON(lparams,auto_unbox = TRUE),verbose=TRUE)
}

#' Projection based on principal component analysis
#'
pcaproj <- function(parametersfile){

  if (file.exists(parametersfile)){
    tryCatch(lp <- jsonlite::fromJSON(parametersfile),
             error = function(c) {
               c$message <- paste0(c$message, " (in ", parametersfile, ")")
               stop(c)
             }
    )
  } else {
      message <- paste0("Parameter file '", parametersfile, "' does not exist.")
      stop(message)
  }

  res <- validate_parameters(lp)

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
  # load `.__T__[:base` to fix `! Objects of type prcomp not supported by autoplot.`
  ggfortify::`.__T__[:base`
  p <- ggplot2::autoplot(tpca, data = cols, colour = colorear,
                         loadings = pbiplot, loadings.colour = 'black',
                         loadings.label = pbiplot,
                         loadings.label.colour = 'black',
                         loadings.label.size = 4) + ggplot2::theme_bw()
  p <- p + ggplot2::labs(title = lp$title,caption = lp$caption)
  p <- p + ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
  print(p)
  if (lp$save==TRUE){
    now <- Sys.time()
    outputfile <- file.path(paste0(lp$filename,"-pca-",format(now, "%Y%m%d_%H%M%S"),".",lp$device))
    ggplot2::ggsave(outputfile,plot=p, device= lp$device,  width = lp$width,
                    height =lp$height, units = "cm")
    print(paste("Projection saved in: ",outputfile))
  }
}


wide2long <- function(filename){
  if (!file.exists(filename)){
    stop(paste("File",filename,"does not exist"))
  }
}

# TODO: create functions to display the required parameters in json structure
