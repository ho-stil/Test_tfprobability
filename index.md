---
title: "Tests on tfprobability"
output: html_document
---



# Introduction

Run some Tests on the Keras interface to tfprobability.

## Confidence Interval

Compare confidence intervals to linear regression results, loess, and quantile random forest for very simple problem: 1-3 predictors with normal ditributed availability and linear/quadratic responce (plus some noise). Check which model generates which kind of confidence interval. Most important / key feature after experience with quantile randnom forest: for local models the confidence intervalls for extrapolation should get very wide.

Gaussian Process via GPflow is another candidate - which could be competitive to Keras-solution for model accuracy as well.

## Performance as compared to tensorflow

Use some standard-problems (e.g. the ones from RStudio-Keras website) to benchmark tfprobability vs tensorflow. I assume the results (means) are similar - but what about the calculation times What is the additional effort?

## performance
