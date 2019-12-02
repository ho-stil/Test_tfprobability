library(data.table)
library(quantregForest)
lExample <- 2E3
set.seed(2019)
DT <- data.table(X = rnorm(lExample),
                 Y = rnorm(lExample))
DT[, Z := pmin(1, pmax(0, 0.45*(2^(-X^2) + 2^(-Y^2) - 2^(-(Y-X)^(-2)) + rnorm(lExample, 0, 0.2))))]
DTint <- with(DT, akima::interp(X, Y, Z))
pin_org <- par("pin")
{
  par(pin = c(4,4))
  with(DTint, image(x, y, z))
  par(pin = pin_org)
}
QRF.DT <- quantregForest(x=DT[, list(X,Y)], y=DT[, Z])
testData <- data.table(X = -50:50 / 10,
                       Y = 0)
testData[, Z_theor := pmin(1, pmax(0, 0.45*(2^(-X^2) + 2^(-Y^2) - 2^(-(Y-X)^(-2)))))]
testData[, Z_Dec1 := predict(QRF.DT, testData[, 1:2], 0.1)]
testData[, Z_med := predict(QRF.DT, testData[, 1:2], 0.5)]
testData[, Z_Dec9 := predict(QRF.DT, testData[, 1:2], 0.9)]
{ # Plot QuantRegForrest-Output
  plot(Z_theor~X, testData, ylim=c(0,1), type="l")
  points(Z_med~X, testData)
  with(testData, segments(X, Z_Dec1, X, Z_Dec9, col = gray(0.5)))
  abline(v=c(min(DT[round(5*(Y-mean(testData$Y)))==0, X]), max(DT[round(5*(Y-mean(testData$Y)))==0, X])), lty="dashed")
}
loess.DT <- loess(Z~X+Y, DT, span = 0.25)
loess.pred.DT <- predict(loess.DT, testData[, 1:2], se = TRUE)
testData$Z_loess <- loess.pred.DT$fit
# calculate limits for comprison: 2x StdError should be same order of magnitude as Decile
testData$Z_loess_upper <- loess.pred.DT$fit + 2*loess.pred.DT$se.fit 
testData$Z_loess_lower <- loess.pred.DT$fit - 2*loess.pred.DT$se.fit
rm(loess.pred.DT)
{ # Plot Loess-Output
  plot(Z_theor~X, testData, ylim=c(0,1), type="l")
  points(Z_loess~X, testData)
  with(testData, segments(X, Z_loess_lower, X, Z_loess_upper, col = gray(0.5)))
  abline(v=c(min(DT[round(5*(Y-mean(testData$Y)))==0, X]), max(DT[round(5*(Y-mean(testData$Y)))==0, X])), lty="dashed")
}
