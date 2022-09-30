#' Title
#' Creates a histogram
#'
#' @param parametersfile json structure containing information to create a histogram
#'
#' @return a ggplot object
#' @export
#'
# #' @examples
histogram <- function(parametersfile){

  # reading list of parameters lp
  lp <- validate_json_file(parametersfile)
  res <- validate_parameters(parametersfile,pschema="histogram_schema.json")

  if (res==FALSE) {
    stop("The json parameters file does not meet the schema")
  }

  print("Print creating the histogram ...")

  print(lp$variables)

  if (length(lp$variables) < 1) {
    cols <- read_data(lp$filename,NULL)
  } else {
    cols <- read_data(lp$filename,lp$variables)
  }

  str(cols)
  list_factors <- select_factors(cols)
  print(class(list_factors))

  list_numeric <- select_numeric(cols)
  print(list_numeric)

  if (! lp$y_variable %in% colnames(cols) ) {
    stop(paste("'",lp$y_variable,"' must be a column in",lp$filename))
  }

  p <- paste(
    "ggplot2::ggplot(cols, ggplot2::aes(","x = lp$y_variable, ",
    if (lp$colour %in% list_factors) {
      "color = lp$colour, fill = lp$colour)) + "
    } else {
      ")) + "
    },
    if (lp$colour %in% grDevices::colors()) {
      paste("ggplot2::geom_histogram(color='lp$colour', fill='lp$colour', ",
            "binwidth = lp$binwidth)", sep = "")
    } else {
      paste("ggplot2::geom_histogram(position = 'identity', alpha = lp$alpha, ",
          "binwidth = lp$binwidth)",  sep = "")
    },
    " + ggplot2::theme_bw() + ",
    "ggplot2::labs(title = 'lp$title', caption = 'lp$caption') + ",
    "ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))",
    sep =""
    )

  p <- stringr::str_replace_all(
    p,
    c("lp\\$y_variable" = lp$y_variable,
      "lp\\$colour" = as.character(lp$colour),
      "lp\\$bin_width" = as.character(lp$bin_width),
      "lp\\$alpha" = as.character(lp$alpha),
      "lp\\$title" = as.character(lp$title),
      "lp\\$caption" = as.character(lp$caption)
      )
    )
  p <- stringr::str_replace_all(p, ",\n    \\)", "\n  \\)")
  print(p)
  p <- eval(parse(text = p))
  print(p)
  # p <- ggplot2::ggplot(data = cols, ggplot2::aes_string(x = lp$col_id,
  #                                                       fill=cgroup
  #                                                       )) +
  #   ggplot2::geom_histogram(color=colorear,alpha=lp$alpha) + ggplot2::theme_bw()
  # p <- p + ggplot2::labs(title = lp$title,caption = lp$caption)
  # p <- p + ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))


  # now <- Sys.time()
  # if (lp$save==TRUE){
  #   outputfile <- file.path(paste0(lp$filename,"-hist-",format(now, "%Y%m%d_%H%M%S"),".",lp$device))
  #   ggplot2::ggsave(outputfile,plot=p, device= lp$device,  width = lp$width,
  #                   height =lp$height, units = "cm")
  #   print(paste("Histogram saved in: ",outputfile))
  # }
  # if (lp$interactive == TRUE) {
  #   print("Creating interactive plot ...")
  #   outputfile <- file.path(paste0(lp$filename,"-hist-",format(now, "%Y%m%d_%H%M%S"),".html"))
  #   ip <- plotly::ggplotly(p)
  #   htmlwidgets::saveWidget(ip, outputfile)
  # }
}


hist_params <- function(){
  json_params <- '{
    "filename": "<path/filename>",
    "variables": [],
    "y-variable": "<varname>",
    "group": "<vargroup>",
    "colour": "black",
    "fill": "lightblue",
    "facet_row": "no-groups",
    "facet_column": "no-groups",
    "bin_width": -1,
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
