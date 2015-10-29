# docker-wso2am
Dockerfile for WSO2 API Manager


### Well Known Addresses (WKA) Clustering

Passing an environment variable like this:

```
WELL_KNOWN_ADDRESSES=worker1.local:4000 worker2.local:4000
```

Would add something like the following to the well known addresses

```
<member>
    <hostName>worker1.local</hostName>
    <port>4000</port>
</member>
<member>
    <hostName>worker2.local</hostName>
    <port>4000</port>
</member>
```
