
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
  now <- Sys.time()
  if (lp$save==TRUE){

    outputfile <- file.path(paste0(lp$filename,"-pca-",format(now, "%Y%m%d_%H%M%S"),".",lp$device))
    ggplot2::ggsave(outputfile,plot=p, device= lp$device,  width = lp$width,
                    height =lp$height, units = "cm")
    print(paste("Projection saved in: ",outputfile))
  }
  if (lp$interactive == TRUE) {
    print("Creating interactive plot ...")
    outputfile <- file.path(paste0(lp$filename,"-pca-",format(now, "%Y%m%d_%H%M%S"),".html"))
    ip <- plotly::ggplotly(p)
    htmlwidgets::saveWidget(ip, outputfile)
    print(paste("Interactive pca plot in: ",outputfile))
  }
}

pca_params <- function(){
  json_params <- '{
    "filename": "<path/filename>",
    "col_ids": ["<var1>","<var2>","<...>","<varN>"],
    "colour": "<categorical varX>",
    "scale": true,
    "biplot": true,
    "height": 10,
    "width": 15,
    "title": "<MyTitle>",
    "caption": "<MyCaption>",
    "save": false,
    "device": "<pdf>",
    "interactive":true
  }'

  djson <- jsonlite::prettify(json_params)
  djson
}


