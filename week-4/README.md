1. Enter via SSH to Public instance from local. Run script.

2. Enter via SSH to Private instance from Public. Run script.

3. Open link provided by Load Balancer.

```
sudo yum update -y
sudo yum install httpd -y
sudo service httpd start
sudo chkconfig httpd on
cd /var/www/html/
sudo echo "hello private" > index.html
```