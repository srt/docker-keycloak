FROM jboss/keycloak

ADD supportReverseProxy.xsl ${JBOSS_HOME}/

RUN set -x \
    && java -jar /usr/share/java/saxon.jar \
       -s:${JBOSS_HOME}/standalone/configuration/standalone.xml \
       -xsl:${JBOSS_HOME}/supportReverseProxy.xsl \
       -o:${JBOSS_HOME}/standalone/configuration/standalone.xml
