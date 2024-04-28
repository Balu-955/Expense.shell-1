#!/bin/bash


USERID=$(id -u)
TIMESTAMP=$(date +%f-%H-%M-%S)
SCRIPTNAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPTNAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


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

