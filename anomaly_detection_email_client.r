install.packages("devtools")
devtools::install_github("twitter/AnomalyDetection")
library(AnomalyDetection)
install.packages("mailR", dep = T)
library(mailR)

source("Mixpanel.r")
source("mixpanel_cleanup.r")

#application level variables
application = "Application Name"
metric = "Login Issues"

cdate = Sys.Date()
edate = cdate - 4

#API Call Variables:
#NOTE: These are only variables required for 
key = "API_KEY"
secret = "SECRET_API_KEY"
start_date = edate
end_date = cdate - 1 #i.e. the system's yesterday
unit = "hour"
interval = 96
event = 'Logins'
type = "total"

#AD variables:
period = "hr"
direction = "neg"
anoms = 0.02

#Email client variables
gmail_un = 'username@gmail.com'
gmail_pw = 'credential123'
email_dist = c("stakeholder1@gmail.com","stakeholder2@gmail.com")
subject = paste("WARNING: Anomaly Detected on ",application)
body = paste("An Anomaly was detected in ", metric, " on ", cdate, " for ",application,sep = "")
anomaly_plot = "anomalies.png"
output_file =  "anomalies.csv"
dataframe_file = "full_data_set.csv"
s_file = "ds_summary.csv"

file_names = list(output_file, s_file, dataframe_file, anomaly_plot)

perform_ad <- function(dataset,period,anoms,direction,anomaly_plot,dataframe_file,s_file){
  #run AD on the dataset
  res = AnomalyDetectionTs(dataset, max_anoms=anoms, direction=direction, only_last=period, plot=TRUE)
  # if there are more than 0 anomalies, generate files to attach to the email
  if (nrow(res$anoms[2]) > 0){
    sstats = summary(dataset[2])
    png(anomaly_plot)
    res$plot
    dev.off()
    write.table(dataset, dataframe_file)
    write.table(sstats, s_file)
    write.table(res$anoms, )
  }
  else break
}


#mixpanel will return a dataframe of timestamps and metric counts from the api into "dataset"
mixpanel(key, secret, event, unit, interval, type)

#our AD is performed and output files generated and saved
perform_ad(dataset,period,anoms,direction,anomaly_plot,dataframe_file,s_file)

#Only load the email client when an email is needed
#Assumes you're sending from gmail- if you need to change this - check out the Rmail documentation:
#https://github.com/rpremraj/mailR
send.mail(from = gmail_un, 
          to = email_dist,
          subject = subject,
          body = body,
          smtp = list(host.name = "smtp.gmail.com", port = 465, user.name = gmail_un, passwd = gmail_pw, ssl = TRUE),
          authenticate = TRUE,
          send = TRUE,
          attach.files = c(output_file, s_file, dataframe_file, anomaly_plot),
          file.names = c(output_file, s_file, dataframe_file, anomaly_plot),
          debug = TRUE)