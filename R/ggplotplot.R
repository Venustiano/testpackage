list_params <- function(fileparams,jsonschema){
  # reading and validating list of parameters lp
  lp <- validate_json_file(fileparams)
  # validating lp against schema
  res <- validate_parameters(fileparams,pschema=jsonschema)
  return(lp)
}

violin <- function(lparams) {

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
  p
}
