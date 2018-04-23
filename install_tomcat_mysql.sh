java_config=$1
tomcat_config=$2
MYSQL_ROOT_PASSWORD=$3

sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_ROOT_PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD"
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server

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
