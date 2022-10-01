list_params <- function(fileparams,jsonschema){
  # reading and validating list of parameters lp
  lp <- validate_json_file(fileparams)
  # validating lp against the jsonschema
  res <- validate_parameters(fileparams,pschema=jsonschema)
  return(lp)
}

#' Title
#'
#' Given a data file an appropriate variables, creates violin plot(s)
#'
#' @param fileparams a json file containing metadata to create a violin plot
#'
#' "filename": <string>
#'
#' "variables": <array of strings representing column names>
#'
#' "y_variable": <string variable to be plotted on the vertical direction>
#'
#' "x_variable: <string, preferable a categorical variable>
#'
#' "factorx": <boolean, whether to convert x_variable into a categorical variable>
#'
#' "position" : <enum, ["dodge", "identity", "dodge2"]>
#'
#' "group": <string, column variable>
#'
#' "colour": <string, a column variable or a predefined color in colors()>
#'
#' "fill": <string, column variable>
#'
#' "linetype": <enum, ["blank", "solid", "dashed", "dotted", "dotdash", "longdash", "twodash"]>
#'
#' "size": <number, line size>
#'
#' "weight": <number, but no used yet>
#'
#' "facet_row": <string, variable name>
#'
#' "facet_column": <string, variable name>
#'
#' "alpha": <number, between 0 and 1>
#'
#' "height": <number, in cm of the output visualization file>
#'
#' "width": <number, in cm of the output visualization file>
#'
#' "title": <string, title of the plot>
#'
#' "caption": <string, caption of the plot>
#'
#' "rotxlabs": <number, rotate x labels in grades>
#'
#' "save": <boolean, save the file?
#'
#' "device": <enum, ["eps", "ps", "tex", "pdf", "jpeg", "tiff", "png", "bmp", "svg"]>
#'
#' "interactive": <boolean, save Interactive version>
#'
#' Further information can be found in \href{https://ggplot2.tidyverse.org/reference/geom_violin.html}{geom_violin} documentation.

#' @return a ggplot object and if indicated in 'fileparams' stores the plot in a file (s)
#' @export
#'
# #' @examples

violin <- function(fileparams) {

  # reading and validating list of parameters lp
  lparams <- validate_json_file(fileparams)
  # validating lp against the violin json schema
  res <- validate_parameters(fileparams,pschema="violin_schema.json")

  dt <- read_data(lparams$filename,lparams$variables)
  # factor variables
  fnames <- select_factors(dt)
  # numeric variables
  nnames <- select_numeric(dt)

  varnames <- colnames(dt)

  if (! lparams$y_variable %in% varnames)
    stop(paste("'",lparams$y_variable,"' must be a column in the file",lparams$filename))

  xvar <- "''"
  if (lparams$x_variable %in% varnames)
    if (lparams$x_variable %in% fnames)
      xvar <- lparams$x_variable
    else if (lparams$factorx == TRUE)
      xvar <- "as.factor(lparams$x_variable)"

  p <- paste(
    "ggplot2::ggplot(dt, ggplot2::aes(","x = xvar, y = lparams$y_variable ",
    if (!is.null(lparams$fill))
      if (lparams$fill %in% fnames)
        ",fill = lparams$fill",
    if (!is.null(lparams$colour))
      if (lparams$colour %in% fnames)
        ", colour = lparams$colour",
    ")) + ggplot2::geom_violin(",
    if (!is.null(lparams$position))
      "position = lparam$position, ",
    if (!is.null(lparams$alpha))
      "alpha = lparams$alpha, ",
    if (!is.null(lparams$linetype))
      "linetype = lparams$linetype, ",
    if (!is.null(lparams$size))
      "size = lparams$size, ",
    if (!is.null(lparams$weight))
      "width = lparams$weight",
    ") + ",
    "ggplot2::theme_bw() +",
   "ggplot2::labs(",
   if (!is.null(lparams$title))
    "title = 'lparams$title'",
    if (!is.null(lparams$caption))
    ", caption = 'lparams$caption'",
    ") + ",
   "ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))",
    sep =""
    )

  if (!is.null(lparams$facet_row) && lparams$facet_row %in% fnames)
    facets <- paste(lparams$facet_row,"~")
  else
    facets <- ". ~"

  if (!is.null(lparams$facet_colum) && lparams$facet_colum %in% fnames)
    facets <- paste(facets,lparams$facet_column)
  else
    facets <- paste(facets,".")

  print(facets)
  if (facets != ". ~ .")
    p <- paste(p, "+ ggplot2::facet_grid(", facets, ")")

  if (!is.null(lparams$rotxlabs))
    p <- paste(p,
      " + ggplot2::theme(\n    ",
        "axis.text.x = ggplot2::element_text(angle = lparams$rotxlabs, hjust = 1))\n")

  p <- stringr::str_replace_all(
    p,
    c("lparams\\$y_variable" = lparams$y_variable,
      "xvar" = as.character(xvar),
      "lparams\\$colour" = as.character(lparams$colour),
      "lparams\\$fill" = as.character(lparams$fill),
      "lparams\\$alpha" = as.character(lparams$alpha),
      "lparams\\$linetype" = as.character(lparams$linetype),
      "lparams\\$position" = as.character(lparams$position),
      "lparams\\$size" = as.character(lparams$size),
      "lparams\\$weight" = as.character(lparams$weight),
      "lparams\\$alpha" = as.character(lparams$alpha),
      "lparams\\$title" = as.character(lparams$title),
      "lparams\\$caption" = as.character(lparams$caption)
    )
  )
  p <- stringr::str_replace_all(p, ",\n    \\)", "\n  \\)")
  print(p)
  p <- eval(parse(text = p))
  print(p)
}
