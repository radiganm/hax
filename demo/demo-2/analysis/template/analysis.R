#!/usr/bin/env Rscript
## analysis.R
## Mac Radigan

  library(MASS)
  library(lattice)
# library(leaps)
# library(car)

  source('radar.R')

  dat.fn <- "./data/all.data"
  dat.df <- read.table(dat.fn, sep="\t", header=TRUE)

  dat.sub.source   <- subset(dat.df, type == "source")
  dat.sub.filter_1 <- subset(dat.df, type == "filter_1")
  dat.sub.filter_2 <- subset(dat.df, type == "filter_2")
  dat.sub.sink     <- subset(dat.df, type == "sink")

  outfile <- "./include/tables/summary.txt"
  sink(outfile)
  cat("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
  cat("\n")
  summary(dat.df)
  cat("\n")
  cat("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
  sink()

 #data_summary <- summary(dat.df)
 #capture.output(data_summary, file=outfile)

  fit <- lm(value ~ paramA + paramB + paramC, data=dat.df)
  outfile <- "./include/tables/fit.txt"
  sink(outfile)
  cat("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
  cat("\n")
  summary(fit)
  cat("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
  cat("\n")
  coefficients(fit)
  cat("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
  cat("\n")
  confint(fit, level=0.95)
 #cat("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
 #cat("\n")
 #fitted(fit)
 #cat("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
 #cat("\n")
 #residuals(fit)
  cat("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
  cat("\n")
  anova(fit)
  cat("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
  cat("\n")
 #vcov(fit)
 #cat("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
 #cat("\n")
 #influence(fit)
 #cat("\n")
 #cat("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
  sink()

  png('figures/fit.png')
  layout(matrix(c(1,2,3,4),2,2))
  plot(fit)
  dev.off()

  outfile <- "./include/tables/stepwise.txt"
  sink(outfile)
  cat("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
  cat("\n")
  step <- stepAIC(fit, direction="both")
  step$anova
  cat("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
  cat("\n")
  sink()

  png('figures/boxplot.png')
  boxplot(value ~ type, data=dat.df, 
    xlab = "Tap Point", ylab = "Latency [nanoseconds]",
    main = "Latency"
  )
  dev.off()

  png('figures/wire.png')
  wireframe(value ~ paramA * paramB, data=dat.df, 
    xlab = "Param A", ylab = "Param B",
    main = "Latency",
    drape = TRUE,
    colorkey = TRUE
  )

  png('figures/hist-source.png')
  hist(dat.sub.source, prob=TRUE, 24)
  dev.off()

# outfile <- "./include/tables/leaps.txt"
# sink(outfile)
# cat("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
# cat("\n")
# attach(dat.df)
# leaps<-regsubsets(value ~ paramA + paramB + paramC, data=dat.df, nbest=10)
# summary(leaps)
# png('figures/leaps-models.png')
# plot(leaps, scale="r2")
# dev.off()
# png('figures/leaps-subset-size.png')
# subsets(leaps, statistic="rsq")
# dev.off()
# cat("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
# cat("\n")
# sink()


png('figures/radar.png')
par(mfcol = c(1, 1))
par(mar = c(1, 1, 2, 1))
webplot(mtcars, "Mazda RX4", main = "Compare Cars")
webplot(mtcars, "Mazda RX4 Wag", add = T, col = "blue", lty = 2)
par(new = T)
par(mar = c(0, 0, 0, 0))
plot(0, type = "n", axes = F)
legend("bottomright", lty = c(1, 2), lwd = 2, col = c("red", "blue"), c("Mazda RX4", 
    "Mazda RX4 Wag"), bty = "n")
dev.off()

## *EOF*
