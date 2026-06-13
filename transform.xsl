<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes" encoding="utf-8" />

  <!-- Ключ 1: Группировка по городам -->
  <xsl:key name="group-city" match="item" use="@city" />

  <!-- Ключ 2: Группировка по связке город + компания -->
  <xsl:key name="group-org" match="item" use="concat(@city, '|', @org)" />

  <xsl:template match="/orgs">
    <html>
      <head>
        <meta charset="UTF-8" />
        <title>Города и компании</title>
      </head>
      <body>
        <h1>Города и компании</h1>
        <ul>
          <!-- Перебираем уникальные города (Москва, Петербург) -->
          <xsl:for-each
            select="item[generate-id(.) = generate-id(key('group-city', @city)[1])]">
            <xsl:sort select="@city" />
            <li>
              <h3>
                <xsl:value-of select="@city" />
              </h3>
              <p>Всего товаров: <xsl:value-of select="count(key('group-city', @city))" /></p>

              <!-- Перебираем уникальные компании в текущем городе -->
              <xsl:for-each
                select="key('group-city', @city)[generate-id(.) = generate-id(key('group-org', concat(@city, '|', @org))[1])]">
                <xsl:sort select="@org" />
                <ul>
                  <li>
                    <h4>
                      <xsl:value-of select="@org" />
                    </h4>
                    <p>Всего товаров: <xsl:value-of select="count(key('group-org', concat(@city, '|', @org)))" /></p>
                    <ul>
                      <!-- Перебираем товары текущей компании -->
                      <xsl:for-each select="key('group-org', concat(@city, '|', @org))">
                        <xsl:sort select="@title" />
                        <li>
                          <xsl:value-of select="@title" />
                        </li>
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
