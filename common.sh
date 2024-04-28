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

cur_root(){
if [ $USERID -ne 0 ]
then
    echo " please super user to run this command"
    exit 1 #manually exit if error comes
else
    echo " you are super user"
fi
}
