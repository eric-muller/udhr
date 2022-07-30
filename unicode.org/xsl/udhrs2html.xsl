<?xml version='1.0' encoding='UTF-8'?>

<!-- output one HTML for each language -->

<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:udhr="http://www.unicode.org/udhr"
  xmlns="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes='udhr'
  version="2.0">


<!-- if "#no", a single HTML document is sent to stdout;
     otherwise, this parameter is a directory, and one HTML per language
     is created there-->
<xsl:param name='split-into'/>

<!-- whether only the demo versions ("yes")
     or all the versions ("no") are processed -->
<xsl:param name='subset'/>

<!-- whether the full text is used ("yes")
     or only the first article ("no") is output -->
<xsl:param name='full'/>



<xsl:output 
  method="xml"
  omit-xml-declaration='yes'
  doctype-public='-//W3C//DTD XHTML 1.0 Strict//EN'
  doctype-system='http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd'
  indent="yes"
  encoding="UTF-8"/>


<xsl:template match='/'>
  <xsl:choose>
    <xsl:when test='$split-into="#no"'>
      <xsl:apply-templates select='udhrs' mode='single'/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select='udhrs' mode='multiple'/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--________________________________________________________________ multiple -->

<xsl:template match='udhrs' mode='multiple'>
    <html lang='en'>
      <head>
        <title>UDHR Index</title>
      </head>
      <body>
        <h3 style="text-align: center;">Universal Declaration of Human Rights - Index</h3>
        <ul>
	  <xsl:apply-templates select='udhr[@stage!=2]' mode='#current'>
	    <xsl:sort select="@n"/>
	  </xsl:apply-templates>
        </ul>
      </body>
    </html>
</xsl:template>

<xsl:template match='udhr' mode='multiple'>
  <xsl:variable name='f'>udhr_<xsl:value-of select='@f'/>.xml</xsl:variable>

  <!--xsl:message select='@f'/-->
  
  <xsl:result-document href='{$split-into}/udhr_{@f}.html'>
    <xsl:apply-templates select='document($f,/)' mode='#current'>
      <xsl:with-param name='name' select='@n'/>
      <xsl:with-param name='lang' select='@bcp47'/>
    </xsl:apply-templates>
  </xsl:result-document>
</xsl:template>

<xsl:template match='udhr:udhr' mode='multiple'>
  <xsl:param name='name'/>
  <xsl:param name='lang'/>
  <html lang='en'>
    <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
      <title>UDHR - <xsl:value-of select='$name'/></title>
    </head>    

    <body dir='ltr'>
      <h3 style='text-align:center'>
        <xsl:text>Universal Declaration of Human Rights - </xsl:text>
        <xsl:value-of select='$name'/>
      </h3>

      <p>&#x00A9; 1996 &#x2013; 2009 The Office of the High Commissioner for Human Rights</p>

      <p>This HTML version prepared by the <i>UDHR in Unicode</i>
	project, <a
	href='https://www.unicode.org/udhr'>http://www.unicode.org/udhr</a>.</p>

      <hr/>

      <div>
        <xsl:attribute name='lang'><xsl:value-of select='$lang'/></xsl:attribute>
        <xsl:attribute name='xml:lang'><xsl:value-of select='$lang'/></xsl:attribute>
        <xsl:attribute name='dir'><xsl:value-of select='//@dir'/></xsl:attribute>
        <xsl:apply-templates/>
      </div>

      <hr/>
    </body>
  </html>
</xsl:template>

<!--__________________________________________________________________ single -->

<xsl:template match='udhrs' mode='single'>
  <xsl:variable name='title1'>
    <xsl:choose>
      <xsl:when test='$full="yes"'>
	<xsl:text>Full text</xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>First article</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name='title2'>
    <xsl:choose>
      <xsl:when test='$subset="yes"'>
	<xsl:text>selected languages</xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>all languages</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <html lang='en'>
    <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
      <title>UDHR - <xsl:value-of select='$title1'/>, <xsl:value-of
      select='$title2'/></title>
    </head>

    <body>
      <h3 style='text-align:center'>Universal Declaration of Human Rights -
      <xsl:value-of select='$title1'/>, <xsl:value-of
      select='$title2'/></h3>

      <p>&#x00A9; 1996 &#x2013; 2009 The Office of the High Commissioner for
      Human Rights</p>

      <p>This HTML version prepared by the <i>UDHR in Unicode</i>
      project, <a
      href='https://www.unicode.org/udhr'>http://www.unicode.org/udhr</a>.</p>

      <hr/>

      <xsl:choose>
	<xsl:when test='$subset="yes"'>
	  <xsl:apply-templates select='udhr[@stage!=2][@demo="y"]' mode='#current'>
	    <xsl:sort lang='en' select='@n'/>
	  </xsl:apply-templates>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates select='udhr[@stage!=2]' mode='#current'>
	    <xsl:sort lang='en' select='@n'/>
	  </xsl:apply-templates>
	</xsl:otherwise>
      </xsl:choose>

      <xsl:if test='$full!="yes"'>
	<hr/>
      </xsl:if>
    </body>
  </html>
</xsl:template>

<xsl:template match='udhr' mode='single'>
  <xsl:variable name='f'>udhr_<xsl:value-of select='@f'/>.xml</xsl:variable>

  <!--xsl:message select='@f'/-->
  
  <xsl:apply-templates select='document($f,/)/udhr:udhr' mode='#current'>
    <xsl:with-param name='name' select='@n'/>
    <xsl:with-param name='lang' select='@bcp47'/>
  </xsl:apply-templates>
</xsl:template>


<xsl:template match='udhr:udhr' mode='single'>
  <xsl:param name='name'/>
  <xsl:param name='lang'/>

  <xsl:choose>
    <xsl:when test='$full="yes"'>
      <h2><xsl:value-of select='$name'/></h2>

      <div>
        <xsl:attribute name='lang'><xsl:value-of select='$lang'/></xsl:attribute>
        <xsl:attribute name='xml:lang'><xsl:value-of select='$lang'/></xsl:attribute>
        <xsl:attribute name='dir'><xsl:value-of select='//@dir'/></xsl:attribute>
	<xsl:apply-templates/>
      </div>

      <hr/>
    </xsl:when>

    <xsl:otherwise>
      <p><xsl:value-of select='$name'/></p>

      <blockquote>
	<p>
          <xsl:attribute name='lang'><xsl:value-of select='$lang'/></xsl:attribute>
          <xsl:attribute name='xml:lang'><xsl:value-of select='$lang'/></xsl:attribute>
          <xsl:attribute name='dir'><xsl:value-of select='@dir'/></xsl:attribute>
	  <xsl:apply-templates select='udhr:article[@number="1"]/udhr:para/text()'/>
	</p>
      </blockquote>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--__________________________________________________________________ common -->

<xsl:template match='udhr:udhr/udhr:title'>
  <h3><xsl:apply-templates/></h3>
</xsl:template>

<xsl:template match='udhr:preamble/udhr:title'>
  <h4><xsl:apply-templates/></h4>
</xsl:template>

<xsl:template match='udhr:article/udhr:title'>
  <h4><xsl:apply-templates/></h4>
</xsl:template>


<xsl:template match='udhr:orderedlist'>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match='udhr:listitem'>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match='udhr:listitem/udhr:para[position()=1]'>
  <p>
    <xsl:choose>
      <xsl:when test='ancestor::udhr:listitem[@tag]'>
	<xsl:value-of select='ancestor::udhr:listitem/@tag'/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:number level='single' count='udhr:listitem' format='1.'/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text> </xsl:text>
    <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match='udhr:listitem/udhr:para[position()!=1]'>
  <p>
    <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match='udhr:para'>
  <p><xsl:apply-templates/></p>
</xsl:template>

</xsl:stylesheet>
