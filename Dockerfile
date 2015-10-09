FROM java:7

ENV JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64

# Copy all the custom files to /files
COPY files /files

# Define a volume where people can mount custom files to override anything in the wso2 product
VOLUME /extra

RUN apt-get update && \
    apt-get install -y zip xmlstarlet && \
    apt-get clean && \
    wget -P /opt --user-agent="testuser" --referer="http://connect.wso2.com/wso2/getform/reg/new_product_download" http://product-dist.wso2.com/products/api-manager/1.9.1/wso2am-1.9.1.zip && \
    unzip /opt/wso2am-1.9.1.zip -d /opt && \
    mv /opt/wso2am-1.9.1 /opt/wso2 && \
    rm /opt/wso2am-1.9.1.zip && \
    wget -P /opt/wso2/repository/components/lib/ https://jdbc.postgresql.org/download/postgresql-9.4-1203.jdbc41.jar && \

    # Overlay /files onto /opt/wso2
    cp -R /files/* /opt/wso2/ && \
    chmod a+x /opt/wso2/bin/*.sh && \

    # Download the property parser (to convert a properties file into property arguments)
    wget -O /opt/wso2/bin/property-parser-1.3.jar https://github.com/MashupMill/property-parser/releases/download/1.3/property-parser-1.3.jar && \

    # Insert the <parameter name="HostnameVerifier">AllowAll</parameter> element ... \
    # this is to allow the HTTPS requests passed through from the api-server to internal servers to allow any hostname \
    xmlstarlet edit --inplace -s "/axisconfig/transportSender[@name='https']" -t elem -n parameter -v AllowAll \
           -i "/axisconfig/transportSender[@name='https']/parameter[not(@name)]" -t attr -n name -v HostnameVerifier \
           /opt/wso2/repository/conf/axis2/axis2.xml && \


    # Tell API Manager to return json when returning auth failure messages.
    # Unfortunately it doesn't appear to support content negotiation :(
    sed -i 's/application\/xml/application\/json/' /opt/wso2/repository/deployment/server/synapse-configs/default/sequences/_auth_failure_handler_.xml

WORKDIR /opt/wso2/
EXPOSE 9443 8280 8243
CMD ["/opt/wso2/bin/entrypoint.sh"]
