# Holland_Andrew_ECON418_FINAL-Estimating-the-Treatment-Effect-of-Minimum-Wage-increases-on-Employment
This repository contains R code creating a Differences-in-Differences model on panel data containing state, time period, and restaurant id parameters. The goal was to estimate the treatment effect (ATT) of a minimum wage increase on total employment for fast-food between February and NOvember of 1992. This is based on the famous study by David Card and Alan Krueger, _Minimum Wages and Employment: A Case Study of the Fast-Food Industry in New Jersey and Pennsylvania._

The code is in the file Holland_Andrew_Exam_3.R

Given the data provided (found in the file ECON_418_518_Exam_3_Data.csv), I was tasked with performing an analysis on the treatment effect of introducing a minimum wage increase in New Jersey as compared to Pennsylvania. I used a Differences-in-Differences Model to analyze the Average Treatment Effect on the Treated (ATT). By doing this, I was able to construct confidence intervals for the ATT at the 95% confidence level. I also examined what would happen if restaurant fixed-effects were introduced to the model and the impact on the ATT. I found no significant difference when fixed-effects were introduced, thus suggesting a robust model. 

This was my final exam for my ECON 418, Introduction to Econometrics course at the University of Arizona.
