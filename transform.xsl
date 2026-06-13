<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <!-- Ключ для группировки товаров по уникальной связке (город+компания) -->
    <xsl:key name="group-by-city-org" match="item" use="concat(@city, '|', @org)" />

    <!-- Главный шаблон -->
    <xsl:template match="/">
        <html>
            <head>
                <meta charset="UTF-8"/>
                <title>Города и компании</title>
            </head>
            <body>
                <h1>Города и компании</h1>
                <ul>
                    <!-- Проходим по уникальным городам -->
                    <xsl:for-each select="//item[generate-id() = generate-id(key('group-by-city-org', concat(@city, '|', @org))[1])]">
                        <xsl:sort select="@city"/>
                        <li>
                            <h3><xsl:value-of select="@city"/></h3>
                            <xsl:variable name="items-in-city" select="//item[@city = current()/@city]"/>
                            <p>Всего товаров: <xsl:value-of select="count($items-in-city)"/></p>
                            <ul>
                                <!-- Группировка компаний внутри текущего города -->
                                <xsl:for-each select="//item[@city = current()/@city][generate-id() = generate-id(key('group-by-city-org', concat(@city, '|', @org))[1])]">
                                    <xsl:sort select="@org"/>
                                    <li>
                                        <h4><xsl:value-of select="@org"/></h4>
                                        <xsl:variable name="items-in-company" select="key('group-by-city-org', concat(@city, '|', @org))"/>
                                        <p>Всего товаров: <xsl:value-of select="count($items-in-company)"/></p>
                                        <ul>
                                            <xsl:for-each select="$items-in-company">
                                                <xsl:sort select="@title"/>
                                                <li><xsl:value-of select="@title"/></li>
                                            </xsl:for-each>
                                        </ul>
                                    </li>
                                </xsl:for-each>
                            </ul>
                        </li>
                    </xsl:for-each>
                </ul>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
