context("report_sea_age")


test_that("test creating an instance of report_sea_age with data loaded (logrami required)",
          {
            skip_on_cran()
            stacomi(database_expected = TRUE, sch ="logrami")
            r_seaa <- new("report_sea_age")
						env_set_test_stacomi()    
						r_seaa <- suppressWarnings(
              choice_c(
                r_seaa,
                dc = c(107, 108, 101),
                horodatedebut = "2012-01-01",
                horodatefin = "2012-12-31",
                limit1hm = 675,
                limit2hm = 875,
                silent = TRUE
              )
            )
            # warnings No data for par 1786No data for par 1785
             expect_error( r_seaa <- connect(r_seaa, silent = TRUE), NA)
            rm(list = ls(envir = envir_stacomi), envir = envir_stacomi)
						
          })

test_that("test that loading bad limits fails", {
  skip_on_cran()
  stacomi(database_expected = FALSE, sch= "logrami")
	env_set_test_stacomi()
  r_seaa <- new("report_sea_age")
  
  expect_error(
    r_seaa <- choice_c(
      r_seaa,
      dc = c(107, 108, 101),
      horodatedebut = "2012-01-01",
      horodatefin = "2012-12-31",
      limit1hm = 675,
      limit2hm = "strawberry",
      silent = FALSE
    )
  )
  rm(list = ls(envir = envir_stacomi), envir = envir_stacomi)
})
