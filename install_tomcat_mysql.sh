java_config=$1
tomcat_config=$2
mysqlPassword=$3

sudo apt-get update
#no password prompt while installing mysql server
#export DEBIAN_FRONTEND=noninteractive

#another way of installing mysql server in a Non-Interactive mode
echo "mysql-server-5.6 mysql-server/root_password password $mysqlPassword" | sudo debconf-set-selections 
echo "mysql-server-5.6 mysql-server/root_password_again password $mysqlPassword" | sudo debconf-set-selections 

#install mysql-server 5.6
sudo apt-get -y install mysql-server-5.6

#set the password
#sudo mysqladmin -u root password "$mysqlPassword"   #without -p means here the initial password is empty

#alternative update mysql root password method
sudo mysql -u root -e "set password for 'root'@'localhost' = PASSWORD('$mysqlPassword')"
#without -p here means the initial password is empty

#sudo service mysql restart

# Install Java
sudo apt-get -y update
sudo apt-get install -y $java_config
sudo apt-get -y update --fix-missing
sudo apt-get install -y $java_config

# Install tomcat
sudo apt-get install -y  $tomcat_config

if netstat -tulpen | grep 8080
then
    sudo wget http://mastervm.centralus.cloudapp.azure.com:8081/nexus/content/repositories/Silos_Repo/com/devops/azure/silos/1.0.0.5/silos-1.0.0.5.war -O /tmp/silos.war
	webapps_dir=/var/lib/tomcat7/webapps
	# Remove existing assets (if any)
	sudo rm -rf $webapps_dir/ROOT
	# Copy WAR file into place
	sudo cp /tmp/silos.war $webapps_dir
	# Restart tomcat
	sudo /etc/init.d/tomcat7 restart
	exit 0
fi
