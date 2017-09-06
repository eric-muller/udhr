<?xml version='1.0' encoding='UTF-8'?>

<!-- output a status HTML for each language -->

<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:udhr="http://www.unhchr.ch/udhr"
  exclude-result-prefixes='udhr'
  version="2.0">


<!-- the directory in which to put the resulting htmls -->
<xsl:param name='targetdir'/>

<xsl:param name='root-dir'/>

<xsl:include href='pages-common.xsl'/>

<xsl:output 
  method="xml"
  omit-xml-declaration='yes'
  doctype-public='-//W3C//DTD XHTML 1.0 Strict//EN'
  doctype-system='http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd'
  indent="no"
  encoding="UTF-8"/>


<xsl:template match='udhrs'>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match='udhr'>
  <xsl:variable name='f'>../status/status_<xsl:value-of select='@f'/>.xml</xsl:variable>

  <!--xsl:message select='@f'/-->
  
  <xsl:result-document href='{$targetdir}/status_{@f}.html'>
    <xsl:apply-templates select='document($f,/)'>
      <xsl:with-param name='name' select='@n'/>
    </xsl:apply-templates>
  </xsl:result-document>
</xsl:template>


</xsl:stylesheet>
