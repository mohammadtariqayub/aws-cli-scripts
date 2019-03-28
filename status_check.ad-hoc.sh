#!/bin/sh
#This script will read /root/vpc_name file and will check Status of all server listed on the vpc_name file and will send mail to admin.
clear
echo " "
for i in `cat vpc_name.ad-hoc`
do
VPC_ID=`echo $i |cut -d "_" -f1`
echo -e "\033[1m\e[32maws-disrd-$VPC_ID\033[0m"
echo "aws-disrd-$VPC_ID" >> /tmp/status_check_mail
echo " "
echo " " >> /tmp/status_check_mail
echo "Below instances are having Status Check failure in `echo "aws-disrd-$VPC_ID"`"
echo "Below instances are having Status Check failure" >> /tmp/status_check_mail
echo " "
echo " " >> /tmp/status_check_mail
aws ec2 describe-instance-status --filters Name=instance-status.status,Values=impaired --profile $i |grep "InstanceId" |cut -d "," -f1
aws ec2 describe-instance-status --filters Name=instance-status.status,Values=impaired --profile $i |grep "InstanceId" |cut -d "," -f1 >> /tmp/status_check_mail
echo " "
echo " " >> /tmp/status_check_mail
done
cat /tmp/status_check_mail |mailx -s "Status check report `date +%x--%H:%M`" mohammad.ayub@industry.nsw.gov.au
rm /tmp/status_check_mail
