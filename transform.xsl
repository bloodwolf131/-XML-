<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <!-- Ключ для группировки товаров по компании в рамках города -->
    <xsl:key name="city-org" match="item" use="concat(@city, '|', @org)" />

    <!-- Ключ для группировки товаров внутри одной компании -->
    <xsl:key name="org-item" match="item" use="concat(@city, '|', @org)" />

    <!-- Главный шаблон -->
    <xsl:template match="/">
        <html>
            <head>
                <title>Города и компании</title>
                <meta charset="UTF-8" />
            </head>
            <body>
                <h1>Города и компании</h1>
                <ul>
                    <!-- Группировка по городам -->
                    <xsl:for-each select="//item[generate-id() = generate-id(key('city-org', concat(@city, '|', @org))[1])]">
                        <xsl:sort select="@city" />
                        <li>
                            <h3><xsl:value-of select="@city"/></h3>
                            <!-- Подсчёт общего количества товаров в городе -->
                            <xsl:variable name="city-items" select="//item[@city = current()/@city]" />
                            <p>Всего товаров: <xsl:value-of select="count($city-items)"/></p>
                            <ul>
                                <!-- Группировка по компаниям внутри города -->
                                <xsl:for-each select="//item[@city = current()/@city][generate-id() = generate-id(key('city-org', concat(@city, '|', @org))[1])]">
                                    <xsl:sort select="@org" />
                                    <li>
                                        <h4><xsl:value-of select="@org"/></h4>
                                        <!-- Подсчёт количества товаров в компании -->
                                        <xsl:variable name="company-items" select="key('city-org', concat(@city, '|', @org))" />
                                        <p>Всего товаров: <xsl:value-of select="count($company-items)"/></p>
                                        <ul>
                                            <!-- Список товаров компании -->
                                            <xsl:for-each select="key('city-org', concat(@city, '|', @org))">
                                                <xsl:sort select="@title" />
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
