FROM java:7

ENV JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64 \
    CARBON_HOME=/opt/wso2

# This is the standard distribution from http://wso2.com/api-management/try-it/
ADD wso2am-1.9.1.zip /opt/

RUN apt-get update && \
    apt-get install -y zip xmlstarlet && \
    apt-get clean && \
    unzip /opt/wso2am-1.9.1.zip -d /opt && \
    mv /opt/wso2am-1.9.1 /opt/wso2 && \
    rm /opt/wso2am-1.9.1.zip

WORKDIR /opt/wso2/
EXPOSE 9443 8280 8243
CMD ["/opt/wso2/bin/wso2server.sh"]
