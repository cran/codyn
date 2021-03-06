context("abundance_change")


# prepare data ----------------------------------------


# Load our example dataset
data("pplots", package = "codyn") 

#take a subset without replicates 
dat1 <- subset(pplots, plot ==25 & year %in% c(2002, 2003))

#make missing abundance
bdat <- dat1
bdat$relative_cover[1] <- NA

#repeat a species
x <- c("N1P0", 25, 1, 2002, "senecio plattensis", 0.002123142)
bdat2 <- rbind(dat1, x)

#make species name missing
bdat3 <- dat1
bdat3$species[1] <- NA
# run tests -------------------------------------------


test_that("abundance_change function returns correct result", {
  
  #test the returned result with default setting
  myresults1 <- abundance_change(dat1, time.var = "year",
                           abundance.var = "relative_cover",
                           species.var = "species")
  
  
  expect_is(myresults1, "data.frame")
  expect_equal(nrow(myresults1), 20)
  expect_equal(ncol(myresults1), 4)
  expect_equal(myresults1$change[1], -0.002123142, tolerance = 0.00001)


  #test that it works with replicates
  myresults2 <- abundance_change(pplots, abundance.var = "relative_cover",
                                    replicate.var = "plot",
                                    species.var = "species",
                                    time.var = "year")
  
  expect_equal(nrow(myresults2), 1148)
  expect_equal(ncol(myresults2), 5) 
  
  #test that is works with reference year
  myresults3 <- abundance_change(pplots, abundance.var = "relative_cover",
                                 replicate.var = "plot",
                                 species.var = "species",
                                 time.var = "year",
                                 reference.time = 2002)
  
  expect_equal(myresults3$change[3], -0.001512000, tolerance = 0.00001)
  
  #test that is doesn't work with missing abundance
  expect_error(abundance_change(bdat, abundance.var = "relative_cover",
                          replicate.var = "plot",
                          species.var = "species",
                          time.var = "year"), "Abundance column contains missing values")
  
  #test that is doesn't work with a repeated species
  expect_error(abundance_change(bdat2, abundance.var = "relative_cover",
                          replicate.var = "plot",
                          species.var = "species",
                          time.var = "year"), "Multiple records for one or more species found at:\n year   plot\n \"2002\" \"25\"")
  
  #test that is doesn't work with missing species name
  expect_error(abundance_change(bdat3, abundance.var = "relative_cover",
                          replicate.var = "plot",
                          species.var = "species",
                          time.var = "year"), "Species names are missing")
  
})
