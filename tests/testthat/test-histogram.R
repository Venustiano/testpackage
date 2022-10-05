test_that("Validating columns", {
  # why the 'expect_error'  messages must be the same

  expect_error(histogram("params/hist_incorrect-col_id.json"),
               "' length ' must be a column in data/iris.csv")

  # p <- histogram("params/hist_buildingpermits.json")
  # expect_s3_class(p,"ggplot")
  }
)
