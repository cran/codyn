context("RAC_difference")


# prepare data ----------------------------------------


# Load our example dataset
data("pplots", package = "codyn") 

#take a subset without time 
dat1 <- subset(pplots, plot %in% c(6, 25) & year == 2002)

#make a subset within a block and no time
dat2 <- subset(pplots, plot %in% c(25, 29) & year == 2002)

#make a subset for 2002 with just N1P0 and N2P0
dat3 <- subset(pplots, treatment %in% c("N2P0", "N1P0") & year == 2002)

#make missing abundance
bdat <- dat1
bdat$relative_cover[1] <- NA

#repeat a species
x <- c("N1P0", 25, 1, 2002, "senecio plattensis", 0.002123142)
bdat2 <- rbind(dat1, x)

#make species name missing
bdat3 <- dat1
bdat3$species[1] <- NA

#make a plot with only one species
bdat4 <-subset(dat2, species %in% c("ambrosia psilostachya","amorpha canescens" ))
# run tests -------------------------------------------


test_that("RAC_difference function returns correct result", {
  
  #test the returned result with default setting and no blocking, pooling or time
  myresults1 <- RAC_difference(dat1, replicate.var = "plot",
                               abundance.var = "relative_cover",
                               species.var = "species")
  
  expect_is(myresults1, "data.frame")
  expect_equal(nrow(myresults1), 1)
  expect_equal(ncol(myresults1), 6)
  expect_equal(myresults1$richness_diff, -0.1923077, tolerance = 0.00001)
  expect_equal(myresults1$evenness_diff, -0.02459961, tolerance = 0.000000001)
  expect_equal(myresults1$rank_diff, 0.1449704, tolerance = 0.00001)
  expect_equal(myresults1$species_diff, 0.2307692, tolerance = 0.00001)

  #test that it works with time
  myresults2 <- RAC_difference(pplots, abundance.var = "relative_cover",
                               replicate.var = "plot",
                               species.var = "species",
                               time.var = "year")
  
  expect_equal(nrow(myresults2), 612)
  expect_equal(ncol(myresults2), 7)
  
  #test that it works with time and treatment specified and a reference treatment
  myresults2.2 <- RAC_difference(pplots, abundance.var = "relative_cover",
                               replicate.var = "plot",
                               species.var = "species",
                               time.var = "year",
                               treatment.var = "treatment",
                               reference.treatment = "N1P0")
  
  expect_equal(nrow(myresults2.2), 288)
  expect_equal(ncol(myresults2.2), 9)
  
  #test that it works with time and treatment specified
  myresults2.3 <- RAC_difference(pplots, abundance.var = "relative_cover",
                                 replicate.var = "plot",
                                 species.var = "species",
                                 time.var = "year",
                                 treatment.var = "treatment")
  
  expect_equal(nrow(myresults2.3), 612)
  expect_equal(ncol(myresults2.3), 9)
  
  #test the returned result with blocking and no time
  myresults3 <- RAC_difference(dat2, replicate.var = "plot",
                               abundance.var = "relative_cover",
                               species.var = "species",
                               block.var = "block",
                               treatment.var = "treatment")
  
  expect_is(myresults3, "data.frame")
  expect_equal(nrow(myresults3), 1)
  expect_equal(ncol(myresults3), 9)
  expect_equal(myresults3$richness_diff, 0, tolerance = 0.00001)
  expect_equal(myresults3$evenness_diff, -0.001809309, tolerance = 0.000001)
  expect_equal(myresults3$rank_diff, 0.1404959, tolerance = 0.00001)
  expect_equal(myresults3$species_diff, 0.3636364, tolerance = 0.00001)
  
  #test that returned results with blocking and time and reference
  myresults3.2 <- RAC_difference(pplots, replicate.var = "plot",
                               abundance.var = "relative_cover",
                               species.var = "species",
                               block.var = "block",
                               treatment.var = "treatment",
                               time.var = "year",
                               reference.treatment = "N1P0")
  
  expect_equal(nrow(myresults3.2), 48)
  expect_equal(ncol(myresults3.2), 10)
  
  #test that returned results with blocking and time
  myresults3.3 <- RAC_difference(pplots, replicate.var = "plot",
                                 abundance.var = "relative_cover",
                                 species.var = "species",
                                 block.var = "block",
                                 treatment.var = "treatment",
                                 time.var = "year")
  
  expect_equal(nrow(myresults3.3), 72)
  expect_equal(ncol(myresults3.3), 10)
  
  
  #test the returned result with pooling and no time
  myresults4 <- RAC_difference(dat3, replicate.var = "plot",
                               abundance.var = "relative_cover",
                               species.var = "species", 
                               pool = TRUE,
                               treatment.var = "treatment")
  
  expect_is(myresults4, "data.frame")
  expect_equal(nrow(myresults4), 1)
  expect_equal(ncol(myresults4), 6)
  expect_equal(myresults4$richness_diff, 0.02439024, tolerance = 0.00001)
  expect_equal(myresults4$evenness_diff, -0.03104394, tolerance = 0.000001)
  expect_equal(myresults4$rank_diff, 0.1171921, tolerance = 0.00001)
  expect_equal(myresults4$species_diff, 0.3414634, tolerance = 0.00001)
  
  #test the returned result with pooling and time and reference treatment
  myresults4.2 <- RAC_difference(pplots, replicate.var = "plot",
                               abundance.var = "relative_cover",
                               species.var = "species", 
                               pool = TRUE,
                               treatment.var = "treatment",
                               time.var = "year",
                               reference.treatment = "N1P0")
  
  expect_equal(nrow(myresults4.2), 8)
  expect_equal(ncol(myresults4.2), 7)
  
  #test the returned result with pooling and time
  myresults4.3 <- RAC_difference(pplots, replicate.var = "plot",
                                 abundance.var = "relative_cover",
                                 species.var = "species", 
                                 pool = TRUE,
                                 treatment.var = "treatment",
                                 time.var = "year")
  
  expect_equal(nrow(myresults4.3), 12)
  expect_equal(ncol(myresults4.3), 7)
  
  #test that is doesn't work with missing abundance
  expect_error(RAC_difference(bdat, abundance.var = "relative_cover",
                              replicate.var = "plot",
                              species.var = "species",
                              time.var = "year"), "Abundance column contains missing values")
  
  #test that is doesn't work with a repeated species
  expect_error(RAC_difference(bdat2, abundance.var = "relative_cover",
                              replicate.var = "plot",
                              species.var = "species",
                              time.var = "year"), "Multiple records for one or more species found at:\n year   plot\n \"2002\" \"25\"")
  
  #test that is doesn't work with missing species name
  expect_error(RAC_difference(bdat3, abundance.var = "relative_cover",
                              replicate.var = "plot",
                              species.var = "species",
                              time.var = "year"), "Species names are missing")
  
  #test that give warning for evenness NA
  expect_warning(RAC_difference(bdat4, abundance.var = "relative_cover",
                                replicate.var = "plot",
                                species.var = "species",
                                time.var = "year"), "evenness_diff values contain NAs because there are plots with only one species")
  
})
