test_that("Validating columns", {
  lp <- validate_json_file("params/pca_parameters.json")
  expect_type(lp,"list")
  validate_parameters("params/pca_parameters.json")

  p <- pcaproj(lp)
  print(p)
  expect_s3_class(p,"ggplot")
}
)
