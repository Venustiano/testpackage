test_that("'col_id' must be a column", {
  # expect_warning(histogram("hist_incorrect-col_id.json"),
  #              "'col_id' must be a column in iris.csv")
  expect_error(histogram("hist_incorrect-col_id.json"),
               "'col_id' must be a column in iris.csv")
  # The following call is not executed
  expect_error(histogram("hist_incorrect-group.json"),
               "'group' must be a column in iris.csv")
  }
)

# test_that("'group' must be a column", {
#   expect_error(histogram("hist_incorrect-group.json"),
#                "The `group' variable must be a categorical in the file.")
#   }
# )
