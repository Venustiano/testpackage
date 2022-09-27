test_that("'col_id' must be a column", {
  expect_error(histogram("hist_incorrect-col_id.json"),
               "The `col_id' variable must be a colum in the file.")
  # The following call is not executed
  # expect_error(histogram("hist_incorrect-group.json"),
  #              "The `group' variable must be a categorical in the file.")
  }
)

test_that("'group' must be a column", {
  expect_error(histogram("hist_incorrect-group.json"),
               "The `group' variable must be a categorical in the file.")
  }
)
