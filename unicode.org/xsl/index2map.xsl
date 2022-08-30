<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  version="2.0">


<xsl:output method='text'/>

<xsl:template match='udhrs'>
var mapMarkers = [
<xsl:for-each-group
      select='udhr'
      group-by='@loc'>
    <xsl:text>[ </xsl:text><xsl:value-of select='current-group()[1]/@loc'/><xsl:text>, [</xsl:text>
    <xsl:apply-templates select='current-group()'/>
    <xsl:text>]],
    </xsl:text>
  </xsl:for-each-group>
];
</xsl:template>

<xsl:template match='udhr'>
 ["<xsl:value-of select='@f'/>", "<xsl:value-of select='@n'/>", "<xsl:value-of select='@iso639-3'/>", "<xsl:value-of select='@bcp47'/>", "<xsl:value-of select='@ohchr'/>", <xsl:value-of select='@stage'/>],
</xsl:template>

</xsl:stylesheet>
