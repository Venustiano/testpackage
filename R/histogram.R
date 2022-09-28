histogram <- function(parametersfile){

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

  res <- validate_parameters(parametersfile,pschema="histogram_schema.json")

  if (res==FALSE) {
    stop("The json parameters file does not meet the schema")
  }

  print("Print creating the histogram ...")
  colorear <- lp$colour

  if (colorear == ""){
    colorear = NULL
  }

  cgroup <- lp$group
  print(cgroup)

  histcols <- lp$col_id
  histcols <- c(histcols,cgroup)

  print(histcols)

  cols <- read_data(lp$filename,histcols)

  if (! lp$col_id %in% colnames(cols) ) {
    stop(paste("'col_id' must be a column in",lp$filename))
  }

  if (! lp$group %in% colnames(cols) ) {
    stop(paste("'group' must be a column in",lp$filename))
  }

  print(str(cols))

  p <- ggplot2::ggplot(data = cols, ggplot2::aes_string(x = lp$col_id,
                                                        fill=cgroup
                                                        )) +
    ggplot2::geom_histogram(color=colorear,alpha=lp$alpha) + ggplot2::theme_bw()
  p <- p + ggplot2::labs(title = lp$title,caption = lp$caption)
  p <- p + ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
  now <- Sys.time()
  if (lp$save==TRUE){
    outputfile <- file.path(paste0(lp$filename,"-hist-",format(now, "%Y%m%d_%H%M%S"),".",lp$device))
    ggplot2::ggsave(outputfile,plot=p, device= lp$device,  width = lp$width,
                    height =lp$height, units = "cm")
    print(paste("Histogram saved in: ",outputfile))
  }
  if (lp$interactive == TRUE) {
    print("Creating interactive plot ...")
    outputfile <- file.path(paste0(lp$filename,"-hist-",format(now, "%Y%m%d_%H%M%S"),".html"))
    ip <- plotly::ggplotly(p)
    htmlwidgets::saveWidget(ip, outputfile)
  }
  p
}


hist_params <- function(){
  json_params <- '{
    "filename": "<path/filename>",
    "col_id": "<varname>",
    "group": "<vargroup>",
    "colour": "black",
    "fill": "lightblue",
    "alpha": 0.5,
	  "height": 10,
	  "width": 15,
	  "title": "Title",
	  "caption":"Caption",
    "save": false,
    "device":"pdf",
    "interactive":false
  }'

  djson <- jsonlite::prettify(json_params)
  djson
}
