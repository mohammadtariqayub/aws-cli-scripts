#!/bin/sh
#This script will read /root/vpc_name file and will check Status of all server listed on the vpc_name file and will send mail to admin.
clear
echo " "
for i in `cat vpc_name`
do
VPC_ID=`echo $i |cut -d "_" -f1`
echo -e "\033[1m\e[32maws-disrd-$VPC_ID\033[0m"
echo "aws-disrd-$VPC_ID" >> /tmp/status_check_mail
echo "aws-disrd-$VPC_ID" >> /tmp/status_check_mail2
echo " "
echo " " >> /tmp/status_check_mail
echo " " >> /tmp/status_check_mail2
echo "`echo "aws-disrd-$VPC_ID"` has `aws ec2 describe-instance-status --filters Name=instance-status.status,Values=impaired --profile $i |grep "InstanceId" | wc -l` impaired Instances , `aws ec2 describe-instance-status --filters Name=instance-state-name,Values=running --profile $i |grep "InstanceId" |wc -l` running instances and `aws ec2 describe-instance-status --include-all --filters Name=instance-state-name,Values=stopped --profile $i |grep "InstanceId" |wc -l` stopped instances"  >> /tmp/status_check_mail2
echo " " >> /tmp/status_check_mail2
echo "`echo "aws-disrd-$VPC_ID"` has `aws ec2 describe-instance-status --filters Name=instance-status.status,Values=impaired --profile $i |grep "InstanceId" | wc -l` impaired Instances , `aws ec2 describe-instance-status --filters Name=instance-state-name,Values=running --profile $i |grep "InstanceId" |wc -l` running instances and `aws ec2 describe-instance-status --include-all --filters Name=instance-state-name,Values=stopped --profile $i |grep "InstanceId" |wc -l` stopped instances"
echo " "
echo "Below instances are having Status Check failure in `echo "aws-disrd-$VPC_ID"`"
echo "Below instances are having Status Check failure" >> /tmp/status_check_mail
echo "Below instances are having Status Check failure" >> /tmp/status_check_mail2
echo " "
echo " " >> /tmp/status_check_mail
echo " " >> /tmp/status_check_mail2
aws ec2 describe-instance-status --filters Name=instance-status.status,Values=impaired --profile $i |grep "InstanceId" |cut -d "," -f1
aws ec2 describe-instance-status --filters Name=instance-status.status,Values=impaired --profile $i |grep "InstanceId" |cut -d "," -f1 >> /tmp/status_check_mail
aws ec2 describe-instance-status --filters Name=instance-status.status,Values=impaired --profile $i |grep "InstanceId" |cut -d "," -f1 >> /tmp/status_check_mail2
echo " "
echo " " >> /tmp/status_check_mail
echo " " >> /tmp/status_check_mail2

echo "Below instances are running in `echo "aws-disrd-$VPC_ID"` " >> /tmp/status_check_mail2
echo " " >> /tmp/status_check_mail2
aws ec2 describe-instance-status --filters Name=instance-state-name,Values=running --profile $i |grep "InstanceId" |cut -d "," -f1 >> /tmp/status_check_mail2
echo " " >> /tmp/status_check_mail2
echo "Below instances are stopped in `echo "aws-disrd-$VPC_ID"` " >> /tmp/status_check_mail2
echo " " >> /tmp/status_check_mail2
aws ec2 describe-instance-status --include-all --filters Name=instance-state-name,Values=stopped --profile $i |grep "InstanceId" |cut -d "," -f1 >> /tmp/status_check_mail2
echo " " >> /tmp/status_check_mail2
done
cat /tmp/status_check_mail |mailx -s "Status check report `date +%x--%H:%M`" mohammad.ayub@industry.nsw.gov.au
cat /tmp/status_check_mail2 |mailx -s "Details Status check report `date +%x--%H:%M`" mohammad.ayub@industry.nsw.gov.au

rm /tmp/status_check_mail
rm /tmp/status_check_mail2
