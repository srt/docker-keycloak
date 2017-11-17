FROM jboss/keycloak

ENV POSTGRES_JDBC_VERSION 42.1.4
ENV POSTGRES_JDBC_DOWNLOAD_URL http://central.maven.org/maven2/org/postgresql/postgresql/${POSTGRES_JDBC_VERSION}/postgresql-${POSTGRES_JDBC_VERSION}.jar

ADD changeDatabase.xsl ${JBOSS_HOME}/
ADD supportReverseProxy.xsl ${JBOSS_HOME}/

RUN set -x \
    && java -jar /usr/share/java/saxon.jar \
       -s:${JBOSS_HOME}/standalone/configuration/standalone.xml \
       -xsl:${JBOSS_HOME}/changeDatabase.xsl \
       -o:${JBOSS_HOME}/standalone/configuration/standalone.xml \
    && java -jar /usr/share/java/saxon.jar \
       -s:${JBOSS_HOME}/standalone/configuration/standalone.xml \
       -xsl:${JBOSS_HOME}/supportReverseProxy.xsl \
       -o:${JBOSS_HOME}/standalone/configuration/standalone.xml \
    && java -jar /usr/share/java/saxon.jar \
       -s:${JBOSS_HOME}/standalone/configuration/standalone-ha.xml \
       -xsl:${JBOSS_HOME}/changeDatabase.xsl \
       -o:${JBOSS_HOME}/standalone/configuration/standalone-ha.xml \
    && mkdir -p ${JBOSS_HOME}/modules/system/layers/base/org/postgresql/jdbc/main \
    && cd ${JBOSS_HOME}/modules/system/layers/base/org/postgresql/jdbc/main \
    && curl -Ls "${POSTGRES_JDBC_DOWNLOAD_URL}" > ${JBOSS_HOME}/modules/system/layers/base/org/postgresql/jdbc/main/postgresql.jar

ADD module.xml ${JBOSS_HOME}/modules/system/layers/base/org/postgresql/jdbc/main/
