<?xml version='1.0' encoding='UTF-8'?>


<!-- output a txt for the first article in multiple languages-->

<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:udhr="http://www.unicode.org/udhr"
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
  method="text"
  indent="no"
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
  <xsl:apply-templates select='udhr[@stage!=2]' mode='#current'/>
</xsl:template>

<xsl:template match='udhr' mode='multiple'>
  <xsl:variable name='f'>udhr_<xsl:value-of select='@f'/>.xml</xsl:variable>

  <!--xsl:message select='@f'/-->
  
  <xsl:result-document href='{$split-into}/udhr_{@f}.txt'>
    <xsl:apply-templates select='document($f,/)' mode='#current'>
      <xsl:with-param name='name' select='@n'/>
    </xsl:apply-templates>
  </xsl:result-document>
</xsl:template>

<xsl:template match='udhr:udhr' mode='multiple'>
  <xsl:param name='name'/>

  <xsl:text>Universal Declaration of Human Rights - </xsl:text> 
  <xsl:value-of select='$name'/>

  <xsl:text>
&#x00A9; 1996 &#x2013; 2009 The Office of the High Commissioner for Human Rights
This plain text version prepared by the &#x201C;UDHR in Unicode&#x201D;
project, https://www.unicode.org/udhr.
---

</xsl:text>

  <xsl:apply-templates select='udhr:title | udhr:note | udhr:preamble | udhr:article' mode='#current'/>
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

<xsl:text>Universal Declaration of Human Right - </xsl:text>
<xsl:value-of select='$title1'/>
<xsl:text>, </xsl:text>
<xsl:value-of select='$title2'/>
<xsl:text>

&#x00A9; 1996 &#x2013; 2009 The Office of the High Commissioner for Human Rights

This plain text version prepared by the "UDHR in Unicode" project,
https://www.unicode.org/udhr.

------
</xsl:text>

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
<xsl:text>

------</xsl:text>
    </xsl:if>
</xsl:template>

<xsl:template match='udhr' mode='single'>
  <xsl:variable name='f'>udhr_<xsl:value-of select='@f'/>.xml</xsl:variable>

  <!--xsl:message select='@f'/-->
  
  <xsl:apply-templates select='document($f,/)/udhr:udhr' mode='#current'>
    <xsl:with-param name='name' select='@n'/>
  </xsl:apply-templates>
</xsl:template>


<xsl:template match='udhr:udhr' mode='single'>
  <xsl:param name='name'/>

  <xsl:choose>
    <xsl:when test='$full="yes"'>
      <xsl:value-of select='$name'/>

      <xsl:apply-templates/>

     <xsl:text>
---- </xsl:text>
    </xsl:when>

    <xsl:otherwise>
      <xsl:value-of select='$name'/>
<xsl:text>
</xsl:text>

  <xsl:apply-templates select='udhr:article[@number="1"]/udhr:para/text()'/>

<xsl:text>

</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--__________________________________________________________________ common -->

<xsl:template match='udhr:udhr/udhr:title'>
  <xsl:apply-templates select='text()'/>
  <xsl:text>

</xsl:text>
</xsl:template>

<xsl:template match='udhr:preamble/udhr:title'>
  <xsl:apply-templates select='text()'/>
  <xsl:text>

</xsl:text>
</xsl:template>

<xsl:template match='udhr:title'>
  <xsl:apply-templates select='text()'/>
  <xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match='udhr:preamble'>
  <xsl:apply-templates select='udhr:title | udhr:para'/>
</xsl:template>

<xsl:template match='udhr:note'>
  <xsl:apply-templates select='udhr:para'/>
</xsl:template>

<xsl:template match='udhr:article'>
  <xsl:text>
</xsl:text>
  <xsl:apply-templates select='udhr:title | udhr:para | udhr:orderedlist'/>
</xsl:template>

<xsl:template match='udhr:orderedlist'>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match='udhr:listitem'>
  <xsl:apply-templates/>
<xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match='udhr:listitem/udhr:para[position()=1]'>
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
</xsl:template>

<xsl:template match='udhr:listitem/udhr:para[position()!=1]'>
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match='udhr:para'>
  <xsl:apply-templates/>
  <xsl:text>

</xsl:text>
</xsl:template>

<xsl:template match='udhr:sup'>
<xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>
