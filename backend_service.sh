#!/bin/bash

source ./common.sh 
cur_root


dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "Disabling nosejs"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "Enabling nodejs 20"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "Install nodejs"

id expense &>>$LOGFILE

if [ $? -ne 0 ]
then
useradd expense &>>$LOGFILE
VALIDATE $? " Creating Expense user"

else
    echo -e "Use already created...$Y SKIPPING $N"
fi


mkdir -p /app &>>$LOGFILE
VALIDATE $? "App directory created"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE
VALIDATE $? "Downloaded the application file"

cd /app
rm -rf /app/*
unzip /tmp/backend.zip &>>$LOGFILE
VALIDATE $? "unzip the files"

cd /app
npm install &>>$LOGFILE
VALIDATE $? " npm files installed"

cp /home/ec2-user/Expense.shell/backend.service /etc/systemd/system/backend.service
VALIDATE $? "Copied backend service file"

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "Daemon reload"

systemctl start backend &>>$LOGFILE
VALIDATE $? "start backend"

systemctl enable backend &>>$LOGFILE
VALIDATE $? "enable backend"

dnf install mysql -y &>>$LOGFILE
VALIDATE $? "Mysql client service installed"

mysql -h 172.31.29.19 -uroot -p${Mysql_password} < /app/schema/backend.sql
VALIDATE $? "schema loading"

systemctl restart backend 
VALIDATE $? "RESTART BACKEND"