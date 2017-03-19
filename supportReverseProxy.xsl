<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:j="urn:jboss:domain:4.0"
                xmlns:u="urn:jboss:domain:undertow:3.0">

    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="//u:http-listener">
        <u:http-listener name="default" socket-binding="http" redirect-socket="proxy-https" proxy-address-forwarding="true"/>
    </xsl:template>

    <xsl:template match="//j:socket-binding[@name='http']">
         <xsl:copy-of select="."/>
         <j:socket-binding name="proxy-https" port="443"/>
    </xsl:template>

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>

