FROM java:7

ENV JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64 \
    CARBON_HOME=/opt/wso2

RUN apt-get update && \
    apt-get install -y zip xmlstarlet && \
    apt-get clean && \
    wget -P /opt --user-agent="testuser" --referer="http://connect.wso2.com/wso2/getform/reg/new_product_download" http://product-dist.wso2.com/products/api-manager/1.9.1/wso2am-1.9.1.zip && \
    unzip /opt/wso2am-1.9.1.zip -d /opt && \
    mv /opt/wso2am-1.9.1 /opt/wso2 && \
    rm /opt/wso2am-1.9.1.zip

WORKDIR /opt/wso2/
EXPOSE 9443 8280 8243
CMD ["/opt/wso2/bin/wso2server.sh"]
