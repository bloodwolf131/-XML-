<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" encoding="utf-8" indent="yes"/>
  
  <!-- Ключ для группировки по городам -->
  <xsl:key name="city-key" match="item" use="city"/>
  
  <!-- Ключ для группировки компаний в пределах города -->
  <xsl:key name="company-key" match="item" use="concat(city, '|', org)"/>
  
  <xsl:template match="/orgs">
    <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <title>Города</title>
      </head>
      <body>
        <h1>Города и компании</h1>
        <ul>
          <!-- Перебираем уникальные города -->
          <xsl:for-each select="item[generate-id() = generate-id(key('city-key', city)[1])]">
            <xsl:variable name="currentCity" select="city"/>
            <xsl:variable name="cityItems" select="key('city-key', $currentCity)"/>
            <li>
              <h3><xsl:value-of select="$currentCity"/></h3>
              <p>Всего товаров: <xsl:value-of select="count($cityItems)"/></p>
              
              <!-- Группируем компании внутри текущего города -->
              <xsl:for-each select="$cityItems[generate-id() = generate-id(key('company-key', concat($currentCity, '|', org))[1])]">
                <xsl:variable name="currentOrg" select="org"/>
                <xsl:variable name="orgItems" select="key('company-key', concat($currentCity, '|', $currentOrg))"/>
                <ul>
                  <li>
                    <h4><xsl:value-of select="$currentOrg"/></h4>
                    <p>Всего товаров: <xsl:value-of select="count($orgItems)"/></p>
                    <ul>
                      <!-- Выводим все товары компании (без дубликатов, сортировка по названию) -->
                      <xsl:for-each select="$orgItems">
                        <xsl:sort select="title"/>
                        <li><xsl:value-of select="title"/></li>
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