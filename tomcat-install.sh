# Install Java
sudo apt-get -y update
sudo apt-get install -y $1
sudo apt-get -y update --fix-missing
sudo apt-get install -y $1

# Install tomcat
sudo apt-get install -y  $2

if netstat -tulpen | grep 8080
then
    sudo wget http://mastervm.centralus.cloudapp.azure.com:8081/nexus/content/repositories/Silos_Repo/com/devops/azure/silos/1.0.0.5/silos-1.0.0.5.war -O /tmp/silos-1.0.0.5.war
	webapps_dir=/var/lib/tomcat7/webapps
	# Remove existing assets (if any)
	sudo rm -rf $webapps_dir/ROOT
	# Copy WAR file into place
	sudo cp /tmp/silos-1.0.0.5.war $webapps_dir
	# Restart tomcat
	sudo /etc/init.d/tomcat7 restart
	exit 0
fi
