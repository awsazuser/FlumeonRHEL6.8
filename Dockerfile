FROM centos:6.8
MAINTAINER testing

USER root
RUN yum install -y wget curl which tar 

# java
RUN curl -LO 'http://download.oracle.com/otn-pub/java/jdk/7u71-b14/jdk-7u71-linux-x64.rpm' -H 'Cookie: oraclelicense=accept-securebackup-cookie'
RUN rpm -i jdk-7u71-linux-x64.rpm
RUN rm jdk-7u71-linux-x64.rpm

ENV JAVA_HOME /usr/java/default
ENV PATH $PATH:$JAVA_HOME/bin
RUN rm /usr/bin/java && ln -s $JAVA_HOME/bin/java /usr/bin/java

#flume
RUN mkdir -p /usr/local/flume
RUN wget -qO- http://archive.apache.org/dist/flume/1.7.0/apache-flume-1.7.0-bin.tar.gz \
  | tar zxvf - -C /usr/local/flume --strip 1

ADD flume-conf.properties /usr/local/flume/conf/flume-conf.properties
ADD flume-env.sh /usr/local/flume/conf/flume-env.sh
RUN chmod 777 /usr/local/flume/conf/flume-env.sh
ADD startup-flume.sh /usr/local/flume/startup-flume.sh

RUN chmod 777 /usr/local/flume/startup-flume.sh

CMD ["/bin/bash" , "/usr/local/flume/startup-flume.sh"]
