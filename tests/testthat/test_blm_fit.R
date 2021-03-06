context("Testing blm fit correctness")

seed <- as.integer(1000 * rnorm(1))
test_that(paste("Deviance of a blm fit can max be equal to lm fit using seed", seed), {
  w0 <- 0.3 ; w1 <- 1.1 ; b <- 1.3
  x <- rnorm(50)
  y <- rnorm(50, w1 * x + w0, 1/b)
  mod <- blm(y~x, beta=b, data=data.frame(x=x, y=y))
  
  expect_gte(deviance(mod), deviance(lm(y~x, data=data.frame(x=x, y=y))))
  
})


seed <- as.integer(1000 * rnorm(1))
test_that(paste("1/var of residuals close to precision of data using seed", seed), {
  w0 <- 0.3 ; w1 <- 1.1 ; b <- 0.1
  x <- rnorm(1000)
  y <- rnorm(1000, w1 * x + w0, 1/sqrt(b))
  mod1000 <- blm(y~x, data=data.frame(x=x, y=y))
  
  expect_equal(1/var(resid(mod1000)), b, tolerance=.1)
  
})


seed <- as.integer(1000 * rnorm(1))
test_that(paste("Covariance of coefficients of a blm fit reflects the precision of the model using seed", seed), {
  
  w0 <- 0.3 ; w1 <- 1.1 ; b <- 1.3
  x <- rnorm(100)
  y <- rnorm(100, w1 * x + w0, 1/b)
  mod13 <- blm(y~x, beta=b, data=data.frame(x=x, y=y))
  covar.blm(mod13)
  
  b33 <- 3.3
  y33 <- rnorm(100, w1 * x + w0, 1/b33)
  mod33 <- blm(y33~x, beta=b33, data=data.frame(x=x, y=y33))
  covar.blm(mod33)
  
  #model with more precision should have smaller variance on the coefficients
  expect_equal(all(as.vector(abs(covar.blm(mod13))) > 
                     as.vector(abs(covar.blm(mod33)))), 
               TRUE)
  
  #model provided with higher precision should have less variance on the 
  #coefficients than equal model provided with higher precision
  mod13b <- blm(y~x, beta=b33, data=data.frame(x=x, y=y))

  expect_equal(all(as.vector(abs(covar.blm(mod13))) > 
                     as.vector(abs(covar.blm(mod13b)))), 
               TRUE)
  
})



seed <- as.integer(1000 * rnorm(1))
test_that(paste("Variance of predicted values increases with distance to data points using seed", seed), {
  
  w0 <- 0.3 ; w1 <- 1.1 ; b <- 1.3
  x <- rnorm(100)
  y <- rnorm(100, w1 * x + w0, 1/b)
  mod <- blm(y~x, beta=b, data=data.frame(x=x, y=y))
  
  x2 <- 0:100
  y2 <- predict(mod, data.frame(x=x2), se.fit=T)
  expect_equal(cor(x2, y2$se.fit, method='spearman'),1)

})



seed <- as.integer(1000 * rnorm(1))
test_that(paste("Roughly 66% of random sampled data using model parameters falls into fitted values +/- sqrt(var) using seed", seed), {
w0 <- 1
w1 <- 2
x <- seq(-100,100,10)
b <- 0.001
y <- w0 + w1*x + rnorm(length(x), mean=0, sd=sqrt(1/b) )
blm_mod_with_b <- blm(y~x, beta = b)

test <- function(){
  y <- w0 + w1*x + rnorm(length(x), mean=0, sd=sqrt(1/b) )
  fits <- fitted(blm_mod_with_b, var=T)
  fits$sd <- sqrt(fits$var)
  pos <- vapply(seq_along(y), function(i) ifelse( (y[i] >= fits$mean[i] - fits$sd[i]) &
                                                    (y[i] <= fits$mean[i] + fits$sd[i]),
                                                  TRUE, FALSE), TRUE )
  sum(pos)/length(pos)
}
tests <- replicate(10000, test())

expect_equal(mean(tests), .65, tolerance = .1)
})


seed <- as.integer(1000 * rnorm(1))
test_that(paste("Self-updating using same data improves fit using seed", seed), {
  w0 <- 0.3 ; w1 <- 1.1 ; b <- 1.3
  x <- rnorm(100)
  y <- rnorm(100, w1 * x + w0, 1/b)
  mod1 <- blm(y~x)
  mod2 <- update(mod1)
  mod3 <- update(mod2)
  mod4 <- update(mod3)
  
  dist_4_vs_4 <- mahal(mod4$posterior, coef(mod4))
  dist_3_vs_4 <- mahal(mod4$posterior, coef(mod3))
  dist_2_vs_4 <- mahal(mod4$posterior, coef(mod2))
  dist_1_vs_4 <- mahal(mod4$posterior, coef(mod1))
  dist_prior_vs_4 <- mahal(mod4$posterior, mod1$prior$means)
  
  expect_equal(dist_4_vs_4, 0)
  expect_lte(dist_3_vs_4, dist_2_vs_4)
  expect_lte(dist_2_vs_4, dist_1_vs_4)
  expect_lte(dist_1_vs_4, dist_prior_vs_4)
  
  dev4 <- deviance(mod4)
  dev3 <- deviance(mod3)
  dev2 <- deviance(mod2)
  dev1 <- deviance(mod1)
  expect_lte(dev4, dev3)
  expect_lte(dev3, dev2)
  expect_lte(dev2, dev1)
})


