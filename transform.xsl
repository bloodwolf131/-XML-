<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" encoding="utf-8" indent="yes"/>

  <!-- Ключ для группировки по городам -->
  <xsl:key name="city-key" match="item" use="@city"/>

  <!-- Ключ для группировки по связке город + компания (учитывает одинаковые названия компаний в разных городах) -->
  <xsl:key name="company-key" match="item" use="concat(@city, '|', @org)"/>

  <xsl:template match="/orgs">
    <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <title>Города</title>
      </head>
      <body>
        <h1>Города и компании</h1>
        <ul>
          <!-- Перебираем уникальные города (Muenchian grouping) -->
          <xsl:for-each select="item[generate-id() = generate-id(key('city-key', @city)[1])]">
            <xsl:sort select="@city"/>
            <li>
              <h3><xsl:value-of select="@city"/></h3>
              <p>Всего товаров: <xsl:value-of select="count(key('city-key', @city))"/></p>

              <!-- Перебираем уникальные компании внутри текущего города -->
              <xsl:for-each select="key('city-key', @city)[generate-id() = generate-id(key('company-key', concat(@city, '|', @org))[1])]">
                <xsl:sort select="@org"/>
                <ul>
                  <li>
                    <h4><xsl:value-of select="@org"/></h4>
                    <p>Всего товаров: <xsl:value-of select="count(key('company-key', concat(@city, '|', @org)))"/></p>
                    <ul>
                      <!-- Выводим все товары данной компании -->
                      <xsl:for-each select="key('company-key', concat(@city, '|', @org))">
                        <xsl:sort select="@title"/>
                        <li><xsl:value-of select="@title"/></li>
                      </xsl:for-each>
                    </ul>
                  </li>
                </ul>
              </xsl:for-each>
            </li>
          </xsl:for-each>
        </ul>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
