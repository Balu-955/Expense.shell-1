#!/bin/bash


USERID=$(id -u)
TIMESTAMP=$(date +%f-%H-%M-%S)
SCRIPTNAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPTNAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
echo "please enter DB password"
read -s "Mysql_password"


VALIDATE(){

if [ $1 -ne 0 ]
then
    echo -e "$2...$R FAILURE $N"
    exit 1
else    
    echo -e "$2...$G SUCCESS $N"

fi

}



if [ $USERID -ne 0 ]
then
    echo " please super user to run this command"
    exit 1 #manually exit if error comes
else
    echo " you are super user"
fi


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

mysql -h 172.31.18.43 -uroot -p${Mysql_password} < /app/schema/backend.sql
VALIDATE $? "schema loading"

systemctl restart backend 
VALIDATE $? "RESTART BACKEND"