FROM ubuntu:20.04
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone&&\
	apt update&& apt install unzip default-jdk git maven wget -y && \
	wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.0.16/bin/apache-tomcat-10.0.16.zip -P /root/ && \
	cd /root/ && unzip apache-tomcat-10.0.16.zip && rm -rf apache-tomcat-10.0.16.zip && \
	cd /root && git clone https://github.com/boxfuse/boxfuse-sample-java-war-hello.git boxfuse && \
	cd boxfuse && mvn package && \
	mv /root/boxfuse/target/*.war /root/apache-tomcat-10.0.16/webapps/hello.war && \
	rm -rf /root/boxfuse/ && apt clean
WORKDIR /root/apache-tomcat-10.0.16/bin
EXPOSE 8080
CMD ["sh", "catalina.sh", "run"]