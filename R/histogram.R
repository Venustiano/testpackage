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

  # TODO: validate the lp$group exists
  # if (!exists(lp$group)) {
  #   cgroup = NULL
  # }
  # print(cgroup)

  histcol <- lp$col_id
  histcol <- c(histcol,cgroup)

  print(histcol)

  tryCatch(cols <- data.table::fread(lp$filename,select = histcol),
           error = function(c) {
             c$message <- paste0(c$message, " (in ", parametersfile, ")")
             stop(c)
           }
  )

  print(str(cols))

  p <- ggplot2::ggplot(data = cols, ggplot2::aes_string(x = lp$col_id,
                                                        fill=cgroup
                                                        )) +
    ggplot2::geom_histogram(color=colorear,alpha=lp$alpha) + ggplot2::theme_bw()
  p <- p + ggplot2::labs(title = lp$title,caption = lp$caption)
  p <- p + ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
  if (lp$save==TRUE){
    now <- Sys.time()
    outputfile <- file.path(paste0(lp$filename,"-pca-",format(now, "%Y%m%d_%H%M%S"),".",lp$device))
    ggplot2::ggsave(outputfile,plot=p, device= lp$device,  width = lp$width,
                    height =lp$height, units = "cm")
    print(paste("Histogram saved in: ",outputfile))
    if (lp$interactive == TRUE) {
      print("Creating interactive plot")
      ip <- plotly::ggplotly(p,height = lp$height*38, width = lp$width*38)
      htmlwidgets::saveWidget(ip, "../test.html")
    }
  }
  p
}
