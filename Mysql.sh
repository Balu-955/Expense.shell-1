#!/bin/bash

source ./common.sh 
cur_root

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "installing Mysql server"



systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "enable mysql"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "start mysql"

# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
# VALIDATE $? "setting Mysql Password"

#below code will be usefull for idempotent nature


mysql -h 172.31.18.43 -uroot -p${Mysql_password} -e 'show databases;' &>>$LOGFILE

if [ $? -ne 0 ]

then
    mysql_secure_installation --set-root-pass ${Mysql_password} &>>$LOGFILE
    VALIDATE $? "Mysql root password setup"
else
    echo -e "Mysql root password already setup...$Y SKIPPED $N"
fi

