<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  version="2.0">

<xsl:template match='links'>
  <p>
    <a href='../d/udhr_{@id}.xml'>XML</a>,
    <a href='../d/udhr_{@id}.txt'>TXT</a>,
    <a href='../d/udhr_{@id}.html'>HTML</a>,
  </p>
</xsl:template>

<xsl:template match='history'>
  <table cellspacing="0" cellpadding="5" border="0">
    <xsl:apply-templates/>
  </table>
</xsl:template>


<xsl:template match='history-entry'>
  <tr valign='top'>
    <td><i><xsl:value-of select='@date'/></i></td>
    <td>&#x00A0;&#x00A0;</td>
    <td><xsl:apply-templates/></td>
  </tr>
</xsl:template>


<xsl:template match='navtitle'>
  <tr>
    <td class="navColTitle"><xsl:apply-templates/></td>
  </tr>
</xsl:template>

<xsl:template match='navitem'>
  <tr>
    <td valign="top" class="navColCell"><xsl:apply-templates/></td>
  </tr>
</xsl:template>


<xsl:template match='bridgehead[@id]' mode='toc'>
  <tr>
    <td valign="top" class="navColCell"><a href='#{@id}'><xsl:apply-templates/></a></td>
  </tr>
</xsl:template>

<xsl:template match='div'>
  <div id='{@id}' style='{@style}'/>
</xsl:template>

<xsl:template match='javascript'/>
<xsl:template match='javascript' mode='head'>
  <script type="text/javascript" language="javascript">
    <xsl:if test="@src">
      <xsl:attribute name="src" select="@src"/>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:text> </xsl:text>
  </script>
</xsl:template>

<xsl:template match='stylesheet'/>
<xsl:template match='stylesheet' mode='head'>
  <link rel="stylesheet" type="text/css" href="{@href}"/>
</xsl:template>


<xsl:template match='article'>
  <html lang="en" xml:lang="en">

    <head>
      <title>UDHR in XML - <xsl:value-of select="title"/></title>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>

      <xsl:apply-templates select='stylesheet' mode='head'/>
      <xsl:apply-templates select='javascript' mode='head'/>

      <style>
.navColTitle { font-weight: bold; }
      </style>
    </head>

    <body text='#330000'>
      <table width="100%" cellpadding="0" cellspacing="0" border="0">
	<tr>
	  <td colspan='2'>
	    <table width="100%" border="0" cellpadding="0" cellspacing="0">
	      <tr>
		<td class="icon"><a class="bar" href="{$root-dir}index.html"><font size="3">UDHR in XML</font></a>
		</td>
	      </tr>
	    </table>
	  </td>
	</tr>
	<tr>
	  <td colspan="2" class="gray">&#x00A0;</td>
	</tr>
	<tr>
	  <td valign="top" width="25%" class="navCol">
	    <table class="navColTable" border="0" width="100%" cellspacing="4" 
		   cellpadding="0">
	      <xsl:apply-templates select='bridgehead[@id]' mode='toc'/>
	      <xsl:apply-templates select='document("../navigation.xml")'/>
	    </table>
	  </td>

	  <td valign="top">
	    <table>
	      <tr>
		<td class="contents" valign="top">
		  <div class='body'>
		    <h1><xsl:value-of select='title'/></h1>
		    <xsl:apply-templates/>
		  </div>

		</td>
	      </tr>
	    </table>
	  </td>
	</tr>
      </table>
    </body>
  </html>
</xsl:template>


<xsl:template match='section'>
  <a>
    <xsl:attribute name='name'>
      <xsl:choose>
	<xsl:when test='@id'>
	  <xsl:value-of select='@id'/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:number level='multiple' count='section|chapter' format='1.1'/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <h3>
      <xsl:number level='multiple' count='section|chapter' format='1.1. '/>
      <xsl:value-of select='title'/>
    </h3>
  </a>
  <xsl:if test='@id'>
    <a name='{@id}'>&#x00A0;</a>
  </xsl:if>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template name='select_id'>
  <xsl:choose>
    <xsl:when test='@id'>
      <xsl:value-of select='@id'/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select='generate-id()'/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template name="toc">
  <xsl:param name='depth'>1</xsl:param>

  <table cellspacing="0" cellpadding="0" border="0">
    <xsl:for-each select='section'>

      <tr>
        <td>
          <xsl:number level='multiple' count='section' format='1.1. '/>
        </td>
        <td>
          &#160;<a>
            <xsl:attribute name='href'>
                <xsl:text>#</xsl:text>
                <xsl:choose>
                  <xsl:when test='@id'>
                    <xsl:value-of select='@id'/>
		  </xsl:when>
		  <xsl:otherwise>
                    <xsl:number level='multiple' count='section' format='1.1'/>
		  </xsl:otherwise>
		</xsl:choose>
            </xsl:attribute>
            <xsl:value-of select='title'/>
          </a>
        </td>
      </tr>

      <xsl:if test="section">
  <xsl:if test='$depth &lt; 2'>
        <tr>
          <td>&#160;</td>
          <td>
            <xsl:call-template name='toc'>
	      <xsl:with-param name='depth'><xsl:value-of select='$depth+1'/></xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
  </xsl:if>
      </xsl:if>

    </xsl:for-each>
  </table>
</xsl:template>



<xsl:template match="articleinfo">
</xsl:template>

<xsl:template match="author">
  <xsl:apply-templates select="firstname"/>
  <xsl:text>&#160;</xsl:text>
  <xsl:apply-templates select="surname"/>
</xsl:template>

<xsl:template match="articleinfo" mode="bottom">
  <hr/>
  <a name="dd"/>
  <h3>Document History</h3>
  <p>Author<xsl:if test='count(author) > 1'>s</xsl:if><xsl:text>:</xsl:text>
     <xsl:for-each select='author'>
       <xsl:if test='position() != 1'>, </xsl:if>
       <xsl:apply-templates/>
     </xsl:for-each></p>
  <xsl:apply-templates select="revhistory"/>
</xsl:template>

<xsl:template match="revhistory">
  <table cellspacing="4" cellpadding="0" border="0">
    <tr>
      <td>Revision</td>
      <td>Date</td>
      <td>Comments</td>
    </tr>
    <xsl:for-each select="revision">
      <tr>
        <td valign="top"><ulink><xsl:attribute name="url">../v<xsl:value-of select="revnumber"/></xsl:attribute><xsl:apply-templates select="revnumber"/></ulink></td>
        <td valign="top"><xsl:apply-templates select="date"/></td>
        <td valign="top">
	  <xsl:choose>
	    <xsl:when test='revremark'>
	      <p><xsl:apply-templates select="revremark"/></p>
	    </xsl:when>
	    <xsl:when test='revdescription'>
	      <xsl:apply-templates select="revdescription"/>
	    </xsl:when>
	  </xsl:choose>
	</td>
      </tr>
    </xsl:for-each>
  </table>
</xsl:template>

<xsl:template match='revdescription'>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="title">
</xsl:template>

<xsl:template match='abstract'>
  <blockquote>
  <xsl:apply-templates/>
  </blockquote>
</xsl:template>

<xsl:template match='note[@role="open"]'>
  <p>
    <table cellspacing="4" border="0" cellpadding="0">
      <tr>
        <td valign="top"><i><u><font color="red">Open:</font></u></i></td>
        <td valign="top"><i><xsl:apply-templates/></i></td>
      </tr>
    </table>
  </p>
</xsl:template>

<xsl:template match='note'>
  <blockquote>
    Note: <xsl:apply-templates/>
  </blockquote>
</xsl:template>


<xsl:template match='bridgehead'>
  <a>
    <xsl:attribute name='name'>
      <xsl:call-template name='select_id'/>
    </xsl:attribute>
    <h3><xsl:apply-templates/></h3>
  </a>
</xsl:template>


<xsl:template match='para'>
  <p>
    <xsl:if test='@role="item"'>
      <b>&#x00A7;<xsl:number level='any' from='/' count='para[@role="item"]' format='1.'/></b> &#xa0;
    </xsl:if>
    <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match='table'>
  <i><xsl:value-of select='title'/></i><br/>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match='figure'>
  <center>
    <table cellpadding="10" style='background-color:#f0f0f0'>
      <tr><td align="center"><xsl:apply-templates/></td></tr>
    </table><br/>
    <i><xsl:value-of select='title'/></i>
  </center>
</xsl:template>

<xsl:template match='informalfigure'>
  <center><xsl:apply-templates/></center>
</xsl:template>

<xsl:template match='screenshot|mediaobject|imageobject'>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match='imagedata'>
  <img style='max-width: 100%;' src='{@fileref}'/>
</xsl:template>

<xsl:template match='itemizedlist'>
  <ul>
    <xsl:apply-templates/>
  </ul>
</xsl:template>

<xsl:template match='orderedlist'>
  <ol>
    <xsl:apply-templates/>
  </ol>
</xsl:template>

<xsl:template match='listitem'>
  <li>
    <xsl:apply-templates/>
  </li>
</xsl:template>

<xsl:template match='para//listitem/para'>
  <div><xsl:apply-templates/></div>
</xsl:template>


<xsl:template match='simplelist'>
  <div style="margin-left: 10pt">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match='member'>
  <xsl:apply-templates/><br/>
</xsl:template>

<xsl:template match='emphasis'>
  <i><xsl:apply-templates/></i>
</xsl:template>

<xsl:template match='firstterm'>
  <i><font color="red"><xsl:apply-templates/></font></i>
</xsl:template>

<xsl:template match='term'>
  <i><xsl:apply-templates/></i>
</xsl:template>

<xsl:template match='navitem/ulink'>
  <a>
    <xsl:attribute name='href'>
      <xsl:if test='not (starts-with(@url,"http:"))'>
        <xsl:value-of select='$root-dir'/>
      </xsl:if>
      <xsl:value-of select='@url'/>
    </xsl:attribute>
    <xsl:if test='@type="newwindow"'>
      <xsl:attribute name='target'>_blank</xsl:attribute>
    </xsl:if>
    <xsl:choose>
      <xsl:when test='text()'>
	<xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select='@url'/>
      </xsl:otherwise>
    </xsl:choose>
  </a>
</xsl:template>
  
<xsl:template match='ulink'>
  <a href='{@url}'>
    <xsl:if test='@type="newwindow"'>
      <xsl:attribute name='target'>_blank</xsl:attribute>
    </xsl:if>
    <xsl:choose>
      <xsl:when test='text()'>
	<xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select='@url'/>
      </xsl:otherwise>
    </xsl:choose>
  </a>
</xsl:template>


<xsl:key name='link-key' match='*[@id]'  use='@id'/>

<xsl:template match='link'>
  <a href='#{@linkend}'><xsl:apply-templates/></a>
</xsl:template>

<xsl:template match='anchor'>
  <a name='{@id}'/>
</xsl:template>




<xsl:template match='citetitle'>
  <i><xsl:apply-templates/></i>
</xsl:template>

<xsl:template match='userinput'>
  <tt><xsl:apply-templates/></tt>
</xsl:template>

<xsl:template match='guimenuitem|guibutton|guilabel|filename'>
  <tt><i><xsl:apply-templates/></i></tt>
</xsl:template>

<xsl:template match='caution'>
  <blockquote><hr/><i><b><font color="red">Editor's note</font></b><xsl:apply-templates/></i><hr/></blockquote>
</xsl:template>



<xsl:template match='blockquote'>
  <blockquote><xsl:apply-templates/></blockquote>
</xsl:template>

<xsl:template match='quote'>
  <i><xsl:apply-templates/></i>
</xsl:template>

<xsl:template match='address'>
  <xsl:apply-templates select='firstname'/>
  <xsl:text> </xsl:text>
  <xsl:apply-templates select='surname'/>
  <br />
  <a>
    <xsl:attribute name='href'>
      <xsl:text>mailto:</xsl:text>
      <xsl:value-of select='email'/>
    </xsl:attribute>
    <xsl:apply-templates select='email'/></a>
  <br />
  <xsl:for-each select='street'>
    <xsl:apply-templates select='.'/> <br/>
  </xsl:for-each>

  <xsl:apply-templates select='city'/>
  <xsl:text>, </xsl:text>
  <xsl:apply-templates select='state'/>
  <xsl:text> </xsl:text>
  <xsl:apply-templates select='postcode'/>
</xsl:template>


<xsl:template match='inlinegraphic'>
  <img src='{@fileref}'/>
</xsl:template>



<xsl:template match='informaltable'>
  <table id="{@id}" width="100%">
    <xsl:apply-templates/>
  </table>
</xsl:template>


<xsl:template match='tgroup'>
  <table cellspacing="2" cellpadding="2" border="0">
    <xsl:apply-templates/>
  </table>
  <xsl:for-each select='.//footnote'>
    <xsl:number level='any' from='tgroup' format='a.'/>
    <xsl:apply-templates/>
  </xsl:for-each>
</xsl:template>

<xsl:template match='tgroup//footnote'>
  <sup><xsl:number level='any' from='tgroup' format='a'/></sup>
</xsl:template>
 
<xsl:template match='thead'>
  <thead><xsl:apply-templates/></thead>
</xsl:template>

<xsl:template match='tbody'>
  <tbody><xsl:apply-templates/></tbody>
</xsl:template>
  
<xsl:template match='row'>
  <tr><xsl:apply-templates/></tr>
</xsl:template>



  
<xsl:template name="colspec.colnum">
  <xsl:param name="colspec" select="."/>
  <xsl:choose>
    <xsl:when test="$colspec/@colnum">
      <xsl:value-of select="$colspec/@colnum"/>
    </xsl:when>
    <xsl:when test="$colspec/preceding-sibling::colspec">
      <xsl:variable name="prec.colspec.colnum">
        <xsl:call-template name="colspec.colnum">
          <xsl:with-param name="colspec"
                          select="$colspec/preceding-sibling::colspec[1]"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:value-of select="$prec.colspec.colnum + 1"/>
    </xsl:when>
    <xsl:otherwise>1</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="calculate.colspan">
  <xsl:param name="entry" select="."/>
  <xsl:variable name="namest" select="$entry/@namest"/>
  <xsl:variable name="nameend" select="$entry/@nameend"/>

  <xsl:variable name="scol">
    <xsl:call-template name="colspec.colnum">
      <xsl:with-param name="colspec"
                      select="$entry/ancestor::tgroup/colspec[@colname=$namest]"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="ecol">
    <xsl:call-template name="colspec.colnum">
      <xsl:with-param name="colspec"
                      select="$entry/ancestor::tgroup/colspec[@colname=$nameend]"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="$ecol - $scol + 1"/>
</xsl:template>



<xsl:template match='thead/row/entry'>
   <th>
    <xsl:if test="@rowspan">
      <xsl:attribute name="rowspan" select="@rowspan"/>
    </xsl:if>
    <xsl:if test="@colspan">
      <xsl:attribute name="colspan" select="@colspan"/>
    </xsl:if>
   <xsl:if test="@align">
     <xsl:attribute name="align">
       <xsl:value-of select="@align"/>
     </xsl:attribute>
   </xsl:if>
   <xsl:if test="@valign">
     <xsl:attribute name="valign">
       <xsl:value-of select="@valign"/>
     </xsl:attribute>
   </xsl:if>
    <xsl:if test="@namest">
      <xsl:attribute name="colspan">
        <xsl:call-template name="calculate.colspan"/>
      </xsl:attribute>
    </xsl:if>
   <xsl:if test="@morerows != '0'">
     <xsl:attribute name="rowspan">
       <xsl:value-of select="@morerows+1"/>
     </xsl:attribute>
   </xsl:if>
   <xsl:choose>
     <xsl:when test='node()|text()'>
       <xsl:apply-templates/>
     </xsl:when>
     <xsl:otherwise>
       <xsl:text>&#160;</xsl:text>
     </xsl:otherwise>
   </xsl:choose>
   </th>
</xsl:template>

<xsl:template match='entry'>
   <td valign='top'>
    <xsl:if test="@rowspan">
      <xsl:attribute name="rowspan" select="@rowspan"/>
    </xsl:if>
    <xsl:if test="@colspan">
      <xsl:attribute name="colspan" select="@colspan"/>
    </xsl:if>
   <xsl:if test="@align">
     <xsl:attribute name="align">
       <xsl:value-of select="@align"/>
     </xsl:attribute>
   </xsl:if>
   <xsl:if test="@valign">
     <xsl:attribute name="valign">
       <xsl:value-of select="@valign"/>
     </xsl:attribute>
   </xsl:if>
    <xsl:if test="@namest">
      <xsl:attribute name="colspan">
        <xsl:call-template name="calculate.colspan"/>
      </xsl:attribute>
    </xsl:if>
   <xsl:if test="@morerows != '0'">
     <xsl:attribute name="rowspan">
       <xsl:value-of select="@morerows+1"/>
     </xsl:attribute>
   </xsl:if>
   <xsl:choose>
     <xsl:when test='node()|text()'>
       <xsl:apply-templates/>
     </xsl:when>
     <xsl:otherwise>
       <xsl:text>&#160;</xsl:text>
     </xsl:otherwise>
   </xsl:choose>
   </td>
</xsl:template>
  

<xsl:template match="literal">
  <tt><font color="blue"><xsl:apply-templates/></font></tt>
</xsl:template>



<xsl:template match='classname'>
  <i>[<xsl:apply-templates/>]</i>
</xsl:template>

<xsl:template match='literallayout/text()'>
  <xsl:call-template name='cr-replace'>
    <xsl:with-param name='text'>
      <xsl:call-template name='trim-cr'>
        <xsl:with-param name='text'>
          <xsl:call-template name='sp-replace'>
            <xsl:with-param name='text' select='.'/>
          </xsl:call-template>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match='programlisting/text()'>
  <tt><xsl:call-template name='cr-replace'>
    <xsl:with-param name='text'>
      <xsl:call-template name='trim-cr'>
        <xsl:with-param name='text'>
          <xsl:call-template name='sp-replace'>
            <xsl:with-param name='text'>
              <xsl:call-template name='tab-replace'>
                <xsl:with-param name='text' select='.'/>
              </xsl:call-template>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template></tt>
</xsl:template>

<xsl:template name='trim-cr'>
  <xsl:param name='text'/>
  <xsl:variable name="cr"><xsl:text>&#xa;</xsl:text></xsl:variable>
  <xsl:choose>
    <xsl:when test='starts-with($text,$cr) and position()=1'>
      <xsl:call-template name='trim-cr'>
        <xsl:with-param name='text' select='substring($text,2)'/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test='substring($text,string-length($text))=$cr and position()=last()'>
      <xsl:call-template name='trim-cr'>
        <xsl:with-param name='text' select='substring($text,1,string-length($text)-1)'/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select='$text'/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
      
<xsl:template name="cr-replace">
  <xsl:param name="text"/>
  <xsl:variable name="cr"><xsl:text>&#xa;</xsl:text></xsl:variable>
  <xsl:choose>
    <xsl:when test="contains($text,$cr)">
      <xsl:value-of select="substring-before($text,$cr)"/>
      <br/><xsl:text>&#xa;</xsl:text>
      <xsl:call-template name="cr-replace">
        <xsl:with-param name="text" select="substring-after($text,$cr)"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$text"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="sp-replace">
  <xsl:param name="text"/>
  <xsl:variable name="sp"><xsl:text> </xsl:text></xsl:variable>
  <xsl:choose>
    <xsl:when test="contains($text,$sp)">
      <xsl:value-of select="substring-before($text,$sp)"/>
      <xsl:text>&#160;</xsl:text>
      <xsl:call-template name="sp-replace">
        <xsl:with-param name="text" select="substring-after($text,$sp)"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$text"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="tab-replace">
  <xsl:param name="text"/>
  <xsl:variable name="sp"><xsl:text>	</xsl:text></xsl:variable>
  <xsl:choose>
    <xsl:when test="contains($text,$sp)">
      <xsl:value-of select="substring-before($text,$sp)"/>
      <xsl:text>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;</xsl:text>
      <xsl:call-template name="tab-replace">
        <xsl:with-param name="text" select="substring-after($text,$sp)"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$text"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match='doc-ref'>
  <xsl:variable name='id' select='@url'/>
  <xsl:variable name='xml'><xsl:value-of select='@url'/>.xml</xsl:variable>
  <a href='{@url}.html'><xsl:value-of select='document($xml,$id)/*/title'/></a><br/>
</xsl:template>


<xsl:template match='varname|function|sgmltag'>
  <tt><xsl:apply-templates/></tt>
</xsl:template>

<xsl:template match='glosslist'>
  <div style='margin-left: 10pt'><dl><xsl:apply-templates/></dl></div>
</xsl:template>

<xsl:template match='glossterm'>
  <dt><xsl:apply-templates/></dt>
</xsl:template>

<xsl:template match='glossdef'>
  <dd><xsl:apply-templates/></dd>
</xsl:template>



<xsl:template match='superscript'>
  <sup><xsl:apply-templates/></sup>
</xsl:template>

<xsl:template match='subscript'>
  <sub><xsl:apply-templates/></sub>
</xsl:template>


<xsl:template match='annot'>
  <span style="text-decoration:underline"><xsl:apply-templates/></span>
    <xsl:text> </xsl:text>
    <xsl:number level='any' from='section' format='[1]'/>
</xsl:template>

<xsl:template match='annotref'>
  <xsl:for-each select='key("link-key",@target)'>
    <span style='background-color: #f0f0f0'>
      <xsl:number level='any' from='section' format='[1]'/>
    </span>
  </xsl:for-each>
</xsl:template>



<xsl:template match='person'>
  <p>  <xsl:number level='multiple' count='person' format='1'/>
<xsl:apply-templates/><hr/></p>
</xsl:template>


<xsl:template name='tocp'>
  <xsl:param name='str'/>
  <xsl:value-of select='$str'/>
</xsl:template>

</xsl:stylesheet>
