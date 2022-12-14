TOMURL="https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.71/bin/apache-tomcat-8.5.71.tar.gz"
sudo yum update -y
sudo yum install epel-release -y

sudo yum install java-1.8.0-openjdk -y
sudo yum install git maven wget -y
cd /tmp/


wget $TOMURL -O tomcatbin.tar.gz
EXTOUT=`tar xzvf tomcatbin.tar.gz` 
TOMDIR=`echo $EXTOUT | cut -d '/' -f1`
sudo useradd --shell /sbin/nologin tomcat
sudo rsync -avzh /tmp/$TOMDIR/ /usr/local/tomcat8/
sudo chown -R tomcat.tomcat /usr/local/tomcat8


sudo rm -rf /etc/systemd/system/tomcat.service

sudo cat <<EOT>> /etc/systemd/system/tomcat.service
[Unit]
Description=Tomcat
After=network.target

[Service]

User=tomcat
Group=tomcat

WorkingDirectory=/usr/local/tomcat8

#Environment=JRE_HOME=/usr/lib/jvm/jre
Environment=JAVA_HOME=/usr/lib/jvm/jre

Environment=CATALINA_PID=/var/tomcat/%i/run/tomcat.pid
Environment=CATALINA_HOME=/usr/local/tomcat8
Environment=CATALINE_BASE=/usr/local/tomcat8

ExecStart=/usr/local/tomcat8/bin/catalina.sh run
ExecStop=/usr/local/tomcat8/bin/shutdown.sh


RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target

EOT


sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl enable tomcat

git clone -b local-setup https://github.com/devopshydclub/vprofile-project.git
cd vprofile-project
mvn install
sudo systemctl stop tomcat
sleep 60
sudo rm -rf /usr/local/tomcat8/webapps/ROOT*
sudo cp target/vprofile-v2.war /usr/local/tomcat8/webapps/ROOT.war
sudo systemctl start tomcat
sleep 120

sudo cat <<EOT>> /usr/local/tomcat8/webapps/ROOT/WEB-INF/classes/application.properties
#JDBC Configutation for Database Connection
jdbc.driverClassName=com.mysql.jdbc.Driver
jdbc.url=jdbc:mysql://db01:3306/accounts?useUnicode=true&characterEncoding=UTF-8&zeroDateTimeBehavior=convertToNull
jdbc.username=admin
jdbc.password=admin123

#Memcached Configuration For Active and StandBy Host
#For Active Host
memcached.active.host=mc01
memcached.active.port=11211
#For StandBy Host
memcached.standBy.host=127.0.0.2
memcached.standBy.port=11211

#RabbitMq Configuration
rabbitmq.address=rmq01
rabbitmq.port=5672
rabbitmq.username=test
rabbitmq.password=test

#Elasticesearch Configuration
elasticsearch.host =192.168.1.85
elasticsearch.port =9300
elasticsearch.cluster=vprofile
elasticsearch.node=vprofilenode

EOT

sudo systemctl restart tomcat
