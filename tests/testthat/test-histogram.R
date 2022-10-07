test_that("Validating columns", {
  # why the 'expect_error'  messages must be the same

  # expect_error(histogram("params/hist_incorrect-col_id.json"),
  #              "' length ' must be a column in data/iris.csv")

  p <- histogram("params/mpg_params.json")
  print(p)
  expect_s3_class(p,"ggplot")
  }
)
