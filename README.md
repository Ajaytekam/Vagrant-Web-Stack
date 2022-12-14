# Setup Java application with Apache tomcat, Nginx and Mysql server using Vagrant

## Steps   

* VM Host `db01`
    * Mysql database is initialized with private ip `192.168.56.15`  
    * `mysql.sh` contains the provison script   
* VM Host `mc01`
    * Memchcahe vm is initialized with private ip `192.168.56.14`   
    * `memcache.sh` contains the provison script   
* VM Host `rmq01`
    * RabbitMQ vm is initialized with private ip `192.168.56.13`  
    * `rabbitmq.sh` contains the provison script   
* VM Host `app01`
    * Apache tomcat vm is initialized with private ip `192.168.56.12`   
    * `tomcat.sh` contains the provison script  
* VM Host `web01`
    * Nginx server vm is initialized with private ip `192.168.56.11`   
    * `nginx.sh` contains the provison script  

## Prerequisites

- JDK 1.8 or later
- Maven 3 or later
- MySQL 5.6 or later

## Technologies 

* Web Application
  * Spring MVC
  * Spring Security
  * Spring Data JPA
  * JSP  
* Maven
* MySQL 
* RabbitMQ 
* Memcache


``` 
        ┌─────┐   
        │NGINX│             
        └─────┘
          |↑
          ||   _______┌─────┐
          ||  //-----→│MySQL│←-----
          ↓|  ↓|      └─────┘----||
    ┌─────────────┐     |↑       ||
    │Tomcat_Server│     ||       ||
    └─────────────┘     ↓|       ||
          |↑        ┌────────┐   ||
          ||        │Memcache│   ||
          ||        └────────┘   || 
          ↓|         ↑|          ||
      ┌────────┐     //          ||
      │RabbitMQ│____//           ||
      └────────┘←----            //
          |↑                    //
          ||___________________//
          ----------------------     
```  

## Command 

```
vagrant up 
```  

Web application can be accessible at `http://192.168.56.11/`
