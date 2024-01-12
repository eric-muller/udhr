<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="2.0">

<xsl:output 
  method="xml"
  indent="no"
  encoding="UTF-8"/>


<xsl:param name='root-dir'></xsl:param>


<xsl:template match='udhrs'>
<article>
  <stylesheet href="cdn/cdn.datatables.net/1.10.7/css/jquery.dataTables.css"/>
  <javascript src="cdn/code.jquery.com/jquery-1.11.1.min.js"/>
  <javascript src="cdn/cdn.datatables.net/1.10.7/js/jquery.dataTables.min.js"/>
  <javascript>
<![CDATA[
function getUrlParameter(sParam)
{
    var sPageURL = window.location.search.substring(1);
    var sURLVariables = sPageURL.split('&');
    for (var i = 0; i != sURLVariables.length; i++) 
    {
        var sParameterName = sURLVariables[i].split('=');
        if (sParameterName[0] == sParam) 
        {
            return sParameterName[1];
        }
    }
  return "";
} 
  $(document).ready(function() {
	$('#translations').DataTable( {
            "order": [[ 1, "asc"]],
            "paging": false,
            "dom": '<"top"f>t<"bottom">i',
            "aoColumnDefs" : [{ 'bSortable': false, 'aTargets': [7] }]
     });

  $('#translations').DataTable().search (decodeURIComponent (getUrlParameter ('search'))).draw ();

} );
]]>
</javascript>

  <title>Translations</title>

  <para>The column “Key” is the internal key used in this database to identify the translations. It has no meaning or relation to any system of tags.</para>

  <para>The column &#x201C;Name&#x201D; links to the Ethnologue entry
  for the language. In this column, we use the primary language name
  given by the Ethnologue, may be followed by a qualifier in parenthesis. You may want to consult the <ulink
  url="http://ethnologue.com">Ethnologue</ulink> to determine the
  primary language name if you have difficulty finding a translation by
  language name.</para>

  <para>The column &#x201C;BCP47&#x201D; is a tentative assignment of
  a <ulink url='http://rfc.net/bcp47.html'>BCP 47</ulink> language
  identifier. In some cases, there are multiple translations with the
  same BCP 47 identifier.</para>

  <para>The column &#x201C;OHCHR&#x201D; links to the OHCHR
  version.</para>

  <para>The column &#x201C;Stage&#x201D; indicates our degree of progress as follows:</para>
      
  <itemizedlist>
    <listitem>1: no known complete translation (<xsl:value-of select='count(udhr[@stage="1"])'/>)</listitem>
    <listitem>2: no conversion to XML started (<xsl:value-of select='count(udhr[@stage="2"])'/>)</listitem>
    <listitem>3: partially converted to XML (often the first article only (<xsl:value-of select='count(udhr[@stage="3"])'/>)</listitem>
    <listitem>4: fully converted to XML (<xsl:value-of select='count(udhr[@stage="4"])'/>)</listitem>
  </itemizedlist>

  <para>The column &#x201C;Deliverables&#x201D; links to the deliverables of the project:</para>

  <itemizedlist>
    <listitem>sh: status and history</listitem>
    <listitem>X: XML</listitem>
    <listitem>T: plain text</listitem>
    <listitem>H: HTML</listitem>
  </itemizedlist>
      
<informaltable id='translations'>
  <thead>
    <row>
      <entry rowspan="2">Key</entry>
      <entry colspan="4">Language</entry>
      <entry rowspan="2">OHCHR</entry>
      <entry rowspan="2">Stage</entry>
      <entry rowspan="2">Deliverables</entry>
    </row>
    <row>
      <entry>Name</entry>
      <entry>639-3</entry>
      <entry>15924</entry>
      <entry>BCP47</entry>
    </row>
  </thead>
  <tbody>
    <xsl:apply-templates select='udhr'/>
  </tbody>
</informaltable>

  </article>
</xsl:template>

<xsl:template match='udhr'>
  <row>
    <entry><xsl:value-of select='@f'/></entry>
    <entry>
       <ulink url='http://www.ethnologue.com/language/{@iso639-3}/'><xsl:value-of select='@n'/></ulink>
     </entry>

    <entry><ulink url='http://https://iso639-3.sil.org/code/{@iso639-3}'><xsl:value-of select='@iso639-3'/></ulink></entry>

    <entry><xsl:value-of select='@iso15924'/></entry>

    <entry><xsl:value-of select='@bcp47'/></entry>

    <xsl:choose>
      <xsl:when test='starts-with(@ohchr,"http")'>
        <entry><ulink url='{@ohchr}'>ohchr</ulink></entry>
      </xsl:when>
      <xsl:when test='@ohchr != ""'>
	<entry><ulink url='http://www.ohchr.org/EN/UDHR/Pages/Language.aspx?LangID={@ohchr}'><xsl:value-of select='@ohchr'/></ulink></entry>
      </xsl:when>
      <xsl:otherwise>
	<entry>&#x00A0;</entry>
      </xsl:otherwise>
    </xsl:choose>

    <entry align='center'><xsl:value-of select='@stage'/></entry>


    <entry>
      <ulink url='s/status_{@f}.html'>sh</ulink>
      <xsl:text>&#x00A0;</xsl:text>

      <xsl:choose>
	<xsl:when test='@stage!=2'><ulink url='d/udhr_{@f}.xml'>X</ulink></xsl:when>
	<xsl:otherwise>&#x00A0;</xsl:otherwise>
      </xsl:choose>
      <xsl:text>&#x00A0;</xsl:text>

      <xsl:choose>
	<xsl:when test='@stage!=2'><ulink url='d/udhr_{@f}.txt'>T</ulink></xsl:when>
	<xsl:otherwise>&#x00A0;</xsl:otherwise>
      </xsl:choose>
      <xsl:text>&#x00A0;</xsl:text>

      <xsl:choose>
	<xsl:when test='@stage!=2'><ulink url='d/udhr_{@f}.html'>H</ulink></xsl:when>
	<xsl:otherwise>&#x00A0;</xsl:otherwise>
      </xsl:choose>
    </entry>

  </row>
</xsl:template>


</xsl:stylesheet>
