test_that("use", {
  lp <- list_params("params/violinparams_test.json","violin_schema.json")
  expect_type(lp,"list")
  print(class(lp$variables))
  # dt <- read_data(lp$filename,lp$variables)
  #print(class(dt))
  # expect_s3_class(dt,"data.table")
  # expect_type(select_factors(dt),"character")

  p <- violin(lp)
  expect_s3_class(p,"ggplot")
  print(p)
})
