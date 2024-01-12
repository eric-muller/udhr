<?xml version='1.0' encoding='UTF-8'?>

<!-- output one HTML for each language -->

<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:udhr="http://efele.net/udhr"
  xmlns="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes='udhr'
  version="2.0">

<xsl:output 
  method="text"
  doctype-public='-//W3C//DTD XHTML 1.0 Strict//EN'
  doctype-system='http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd'
  indent="yes"
  encoding="UTF-8"/>


<!--________________________________________________________________ multiple -->

<xsl:template match='udhr'>
  <xsl:variable name='f'>udhr_<xsl:value-of select='@f'/>.xml</xsl:variable>
  <xsl:if test='@stage != "2"'>
    <xsl:variable name='doc' select='document($f,/)'/>
    <xsl:if test="@f != $doc/udhr:udhr/@key">
      <xsl:message>index/@f='<xsl:value-of select='@f'/>' does not match <xsl:value-of select='$f'/>/@key='<xsl:value-of select='$doc/udhr:udhr/@key'/>'</xsl:message>
    </xsl:if>

    <xsl:if test="@iso639-3 != $doc/udhr:udhr/@iso639-3">
      <xsl:message>index/@iso639-3='<xsl:value-of select='@iso639-3'/>' does not match <xsl:value-of select='$f'/>/@iso639-3='<xsl:value-of select='$doc/udhr:udhr/@iso639-3'/>'</xsl:message>
    </xsl:if>

    <xsl:if test="@iso15924 != $doc/udhr:udhr/@iso15924">
      <xsl:message>index/@iso15924='<xsl:value-of select='@iso15924'/>' does not match <xsl:value-of select='$f'/>/@iso15924='<xsl:value-of select='$doc/udhr:udhr/@iso15924'/>'</xsl:message>
    </xsl:if>

    <xsl:if test='@bcp47 != $doc/udhr:udhr/@xml:lang'>
      <xsl:message>index/@bcp47='<xsl:value-of select='@bcp47'/>' does not match <xsl:value-of select='$f'/>/@xml:lang='<xsl:value-of select='$doc/udhr:udhr/@xml:lang'/>'</xsl:message>
    </xsl:if>

    <xsl:if test='@dir != $doc/udhr:udhr/@dir'>
      <xsl:message>index/@dir='<xsl:value-of select='@dir'/>' does not match <xsl:value-of select='$f'/>/@dir='<xsl:value-of select='$doc/udhr:udhr/@dir'/>'</xsl:message>
    </xsl:if>

    <xsl:if test='@n != $doc/udhr:udhr/@n'>
      <xsl:message>index/@n='<xsl:value-of select='@n'/>' does not match <xsl:value-of select='$f'/>/@n='<xsl:value-of select='$doc/udhr:udhr/@n'/>'</xsl:message>
    </xsl:if>

  </xsl:if>
</xsl:template>

<xsl:template match='text()'/>

</xsl:stylesheet>
