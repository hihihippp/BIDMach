
cd /opt/spark/ec2

# launch a cluster
./spark-ec2 -k "pils_rsa" -i /home/ec2-user/.ssh/jfc_rsa -s 32 --instance-type=m3.xlarge --region=us-west-2 launch sparkcluster

# ganglia patch

MASTER=`./spark-ec2 -k "pils_rsa" -i /home/ec2-user/.ssh/jfc_rsa --region=us-west-2 get-master sparkcluster | tail -n 1`
scp -i ~/.ssh/jfc_rsa ~/httpd.conf ec2-user@${MASTER}:httpd.conf

# login to the master
./spark-ec2 -k "pils_rsa" -i /home/ec2-user/.ssh/jfc_rsa --region=us-west-2 login sparkcluster

export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=

# ganglia patch

rm -r /var/lib/ganglia/rrds
ln -s /mnt/ganglia/rrds /var/lib/ganglia/rrds

cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd_bkup.conf
cp /home/ec2-user/httpd.conf /etc/httpd/conf/httpd.conf
apachectl -k graceful

spark/bin/spark-shell

exit

echo "y" | ./spark-ec2 -k "pils_rsa" -i /home/ec2-user/.ssh/jfc_rsa --region=us-west-2 destroy sparkcluster


