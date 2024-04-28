#!/bin/bash

source ./common.sh 
cur_root

dnf install nginx -y &>>$LOGFILE
VALIDATE $? "Install Nginx"

systemctl enable nginx &>>$LOGFILE
VALIDATE $? "Enable Nginx"

systemctl start nginx &>>$LOGFILE
VALIDATE $? "Start Nginx"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE
VALIDATE $? "removing exisiting files"


curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGFILE
VALIDATE $? "Download front end application file"

cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>$LOGFILE
VALIDATE $? "Extarct frontend application file"

cp /home/ec2-user/Expense.shell/expense.conf /etc/nginx/default.d/expense.conf &>>$LOGFILE
VALIDATE $? "Copied Front end service file"

systemctl restart nginx &>>$LOGFILE
VALIDATE $? "Restarted nginx"

