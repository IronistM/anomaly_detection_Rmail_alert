# anomaly_detection_Rmail_alert

This script pulls time series data from Mixpanel and checks to see whether anomalies are present using Twitters AnomalyDetection package in R.

The script is intended to be run on a task scheduler for the lapsed period in which you would like to recieve email notifications that an anomaly has occurred.

It is based off of the following R code on GitHub:

  mailR: https://github.com/rpremraj/mailR
  
  AnomalyDetection: https://github.com/twitter/AnomalyDetection
  
  Mixpanel-API-to-R: https://github.com/megfitz/mixpanel-API-to-R
