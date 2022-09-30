test_that("Validating columns", {
  # why the 'expect_error'  messages must be the same

  expect_error(histogram("params/hist_incorrect-col_id.json"),
               "' length ' must be a column in data/iris.csv")

  # expect_error(histogram("hist_incorrect-group.json"),
  #              "'col_id' must be a column in iris.csv")

  # expect_error(histogram("hist_missing-group.json"),
  #              "did not throw the expected error")

  }
)
