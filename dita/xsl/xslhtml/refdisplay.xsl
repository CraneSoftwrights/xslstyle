<?xml version="1.0" encoding="UTF-8" ?>
<!-- This file is part of the DITA Open Toolkit project hosted on 
     Sourceforge.net. See the accompanying license.txt file for 
     applicable licenses.-->
<!-- (c) Copyright IBM Corp. 2004, 2005 All Rights Reserved. -->

<xsl:stylesheet version="1.0"
     xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- XHTML output with XML syntax -->
<xsl:output method="xml"
            encoding="utf-8"
            indent="no"
/>

<!-- == REFERENCE UNIQUE SUBSTRUCTURES == -->

<!-- Process the header row in a properties table -->
<xsl:template match="*[contains(@class,' reference/prophead ')]" name="topic.reference.prophead">
  <xsl:param name="width-multiplier"/>
  <tr>
   <xsl:call-template name="setid"/>
   <xsl:call-template name="commonattributes"/>
   <xsl:value-of select="$newline"/>
     <!-- For each of the 3 entry types: If the entry is in this row, apply-templates.
          Otherwise, if it is ever in this table, create empty entry, and add ID for accessibility. -->
     <xsl:choose>      <!-- Process <proptype> -->
       <xsl:when test="*[contains(@class,' reference/proptypehd ')]">
         <xsl:apply-templates select="*[contains(@class,' reference/proptypehd ')]">
           <xsl:with-param name="width-multiplier"><xsl:value-of select="$width-multiplier"/></xsl:with-param>
         </xsl:apply-templates>
       </xsl:when>
       <xsl:when test="following-sibling::*/*[contains(@class,' reference/proptype ')]">
         <th valign="bottom">           
           <xsl:attribute name="id"><xsl:value-of select="generate-id(parent::*)"/>-type</xsl:attribute>
           <xsl:call-template name="th-align"/>
           <xsl:call-template name="getString">
             <xsl:with-param name="stringName" select="'Type'"/>
           </xsl:call-template>
         </th><xsl:value-of select="$newline"/>
       </xsl:when>
     </xsl:choose>
     <xsl:choose>      <!-- Process <propvalue> -->
       <xsl:when test="*[contains(@class,' reference/propvaluehd ')]">
         <xsl:apply-templates select="*[contains(@class,' reference/propvaluehd ')]">
           <xsl:with-param name="width-multiplier"><xsl:value-of select="$width-multiplier"/></xsl:with-param>
         </xsl:apply-templates>
       </xsl:when>
       <xsl:when test="following-sibling::*/*[contains(@class,' reference/propvalue ')]">
         <th valign="bottom">           
           <xsl:attribute name="id"><xsl:value-of select="generate-id(parent::*)"/>-value</xsl:attribute>
           <xsl:call-template name="th-align"/>
           <xsl:call-template name="getString">
             <xsl:with-param name="stringName" select="'Value'"/>
           </xsl:call-template>
         </th><xsl:value-of select="$newline"/>
       </xsl:when>
     </xsl:choose>
     <xsl:choose>      <!-- Process <propdesc> -->
       <xsl:when test="*[contains(@class,' reference/propdeschd ')]">
         <xsl:apply-templates select="*[contains(@class,' reference/propdeschd ')]">
           <xsl:with-param name="width-multiplier"><xsl:value-of select="$width-multiplier"/></xsl:with-param>
         </xsl:apply-templates>
       </xsl:when>
       <xsl:when test="following-sibling::*/*[contains(@class,' reference/propdesc ')]">
         <th valign="bottom">           
           <xsl:attribute name="id"><xsl:value-of select="generate-id(parent::*)"/>-desc</xsl:attribute>
           <xsl:call-template name="th-align"/>
           <xsl:call-template name="getString">
             <xsl:with-param name="stringName" select="'Description'"/>
           </xsl:call-template>
         </th><xsl:value-of select="$newline"/>
       </xsl:when>
     </xsl:choose>
  </tr>
</xsl:template>

<!-- Add the headers attribute to a cell inside the properties table. This may be called from either
     a <property> row or from a cell inside the row. -->
<xsl:template name="addPropertiesHeadersAttribute">
  <xsl:param name="classVal"/>
  <xsl:param name="elementType"/>
  <xsl:attribute name="headers">
    <xsl:choose>
      <!-- First choice: if there is a matching cell inside a user-specified header, and it has an ID -->
      <xsl:when test="ancestor::*[contains(@class,' reference/properties ')]/*[1][contains(@class,' reference/prophead ')]/*[contains(@class,$classVal)]/@id">
        <xsl:value-of select="ancestor::*[contains(@class,' reference/properties ')]/*[1][contains(@class,' reference/prophead ')]/*[contains(@class,$classVal)]/@id"/>
      </xsl:when>
      <!-- Second choice: if there is a matching cell inside a user-specified header, use its generated ID -->
      <xsl:when test="ancestor::*[contains(@class,' reference/properties ')]/*[1][contains(@class,' reference/prophead ')]/*[contains(@class,$classVal)]">
        <xsl:value-of select="generate-id(ancestor::*[contains(@class,' reference/properties ')]/*[1][contains(@class,' reference/prophead ')]/*[contains(@class,$classVal)])"/>
      </xsl:when>
      <!-- Third choice: no user-specified header for this column. ID is based on the table's generated ID. -->
      <xsl:otherwise>
        <xsl:value-of select="generate-id(ancestor::*[contains(@class,' reference/properties ')])"/>-<xsl:value-of select="$elementType"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
</xsl:template>

<!-- Process a standard row in the properties table. Apply-templates on the entries one at a time;
     if one is missing which should be present, create an empty cell. -->
<xsl:template match="*[contains(@class,' reference/property ')]" name="topic.reference.property">
  <xsl:param name="width-multiplier"/>
  <!-- If there was no header, then this is the first child of properties; create default headers -->
  <xsl:if test=".=../*[1]">
    <tr><xsl:value-of select="$newline"/>
      <xsl:if test="../*/*[contains(@class,' reference/proptype ')]">
        <th id="{generate-id(parent::*)}-type" valign="bottom">
          <xsl:call-template name="th-align"/>
          <xsl:call-template name="getString">
            <xsl:with-param name="stringName" select="'Type'"/>
          </xsl:call-template>
        </th><xsl:value-of select="$newline"/>
      </xsl:if>
      <xsl:if test="../*/*[contains(@class,' reference/propvalue ')]">
        <th id="{generate-id(parent::*)}-value" valign="bottom">
          <xsl:call-template name="th-align"/>
          <xsl:call-template name="getString">
            <xsl:with-param name="stringName" select="'Value'"/>
          </xsl:call-template>
        </th><xsl:value-of select="$newline"/>
      </xsl:if>
      <xsl:if test="../*/*[contains(@class,' reference/propdesc ')]">
        <th id="{generate-id(parent::*)}-desc" valign="bottom">
          <xsl:call-template name="th-align"/>
          <xsl:call-template name="getString">
            <xsl:with-param name="stringName" select="'Description'"/>
          </xsl:call-template>
        </th><xsl:value-of select="$newline"/>
      </xsl:if>
    </tr><xsl:value-of select="$newline"/>
  </xsl:if>
  <tr>
   <xsl:call-template name="setid"/>
   <xsl:call-template name="commonattributes"/>
   <xsl:value-of select="$newline"/>
     <!-- For each of the 3 entry types:
          - If it is in this row, apply
          - Otherwise, if it is in the table at all, create empty entry -->
     <xsl:choose>      <!-- Process or create proptype -->
       <xsl:when test="*[contains(@class,' reference/proptype ')]">
         <xsl:apply-templates select="*[contains(@class,' reference/proptype ')]">
           <xsl:with-param name="width-multiplier"><xsl:value-of select="$width-multiplier"/></xsl:with-param>
         </xsl:apply-templates>
       </xsl:when>
       <xsl:when test="../*/*[contains(@class,' reference/proptype ')] | ../*[1]/*[contains(@class,' reference/proptypehd ')]">
         <td>    <!-- Create an empty cell. Add accessiblity attribute. -->
           <xsl:call-template name="addPropertiesHeadersAttribute">
             <xsl:with-param name="classVal"> reference/proptypehd </xsl:with-param>
             <xsl:with-param name="elementType">type</xsl:with-param>
           </xsl:call-template>
           <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
         </td><xsl:value-of select="$newline"/>
       </xsl:when>
     </xsl:choose>
     <xsl:choose>      <!-- Process or create propvalue -->
       <xsl:when test="*[contains(@class,' reference/propvalue ')]">
         <xsl:apply-templates select="*[contains(@class,' reference/propvalue ')]">
           <xsl:with-param name="width-multiplier"><xsl:value-of select="$width-multiplier"/></xsl:with-param>
         </xsl:apply-templates>
       </xsl:when>
       <xsl:when test="../*/*[contains(@class,' reference/propvalue ')] | ../*[1]/*[contains(@class,' reference/propvaluehd ')]">
         <td>    <!-- Create an empty cell. Add accessiblity attribute. -->
           <xsl:call-template name="addPropertiesHeadersAttribute">
             <xsl:with-param name="classVal"> reference/propvaluehd </xsl:with-param>
             <xsl:with-param name="elementType">value</xsl:with-param>
           </xsl:call-template>
           <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
         </td><xsl:value-of select="$newline"/>
       </xsl:when>
     </xsl:choose>
     <xsl:choose>      <!-- Process or create propdesc -->
       <xsl:when test="*[contains(@class,' reference/propdesc ')]">
         <xsl:apply-templates select="*[contains(@class,' reference/propdesc ')]">
           <xsl:with-param name="width-multiplier"><xsl:value-of select="$width-multiplier"/></xsl:with-param>
         </xsl:apply-templates>
       </xsl:when>
       <xsl:when test="../*/*[contains(@class,' reference/propdesc ')] | ../*[1]/*[contains(@class,' reference/propdeschd ')]">
         <td>    <!-- Create an empty cell. Add accessiblity attribute. -->
           <xsl:call-template name="addPropertiesHeadersAttribute">
             <xsl:with-param name="classVal"> reference/propdeschd </xsl:with-param>
             <xsl:with-param name="elementType">desc</xsl:with-param>
           </xsl:call-template>
           <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
         </td><xsl:value-of select="$newline"/>
       </xsl:when>
     </xsl:choose>
  </tr><xsl:value-of select="$newline"/>
</xsl:template>

<xsl:template match="*[contains(@class,' reference/proptype ')]" name="topic.reference.proptype">
  <xsl:param name="width-multiplier">0</xsl:param>
  <xsl:apply-templates select="." mode="propertiesEntry">
    <xsl:with-param name="width-multiplier"><xsl:value-of select="$width-multiplier"/></xsl:with-param>
    <xsl:with-param name="elementType">type</xsl:with-param>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="*[contains(@class,' reference/propvalue ')]" name="topic.reference.propvalue">
  <xsl:param name="width-multiplier">0</xsl:param>
  <xsl:apply-templates select="." mode="propertiesEntry">
    <xsl:with-param name="width-multiplier"><xsl:value-of select="$width-multiplier"/></xsl:with-param>
    <xsl:with-param name="elementType">value</xsl:with-param>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="*[contains(@class,' reference/propdesc ')]" name="topic.reference.propdesc">
  <xsl:param name="width-multiplier">0</xsl:param>
  <xsl:apply-templates select="." mode="propertiesEntry">
    <xsl:with-param name="width-multiplier"><xsl:value-of select="$width-multiplier"/></xsl:with-param>
    <xsl:with-param name="elementType">desc</xsl:with-param>
  </xsl:apply-templates>
</xsl:template>

<!-- Template based on the stentry template in dit2htm. Only change is to add elementType
     paramenter, and call addPropertiesHeadersAttribute instead of output-stentry-headers. -->
<xsl:template match="*" mode="propertiesEntry">
  <xsl:param name="width-multiplier">0</xsl:param>
  <xsl:param name="elementType"/>
  <td valign="top">
    <xsl:call-template name="output-stentry-id"/>
    <xsl:call-template name="addPropertiesHeadersAttribute">
      <xsl:with-param name="classVal"> reference/prop<xsl:value-of select="$elementType"/>hd<xsl:text> </xsl:text></xsl:with-param>
      <xsl:with-param name="elementType"><xsl:value-of select="$elementType"/></xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="commonattributes"/>
    <xsl:variable name="localkeycol">
      <xsl:choose>
        <xsl:when test="ancestor::*[contains(@class,' topic/simpletable ')]/@keycol">
          <xsl:value-of select="ancestor::*[contains(@class,' topic/simpletable ')]/@keycol"/>
        </xsl:when>
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- Determine which column this entry is in. -->
    <xsl:variable name="thiscolnum"><xsl:value-of select="number(count(preceding-sibling::*)+1)"/></xsl:variable>
    <!-- If width-multiplier=0, then either @relcolwidth was not specified, or this is not the first
         row, so do not create a width value. Otherwise, find out the relative width of this column. -->
    <xsl:variable name="widthpercent">
      <xsl:if test="$width-multiplier != 0">
        <xsl:call-template name="get-current-entry-percentage">
          <xsl:with-param name="multiplier"><xsl:value-of select="$width-multiplier"/></xsl:with-param>
          <xsl:with-param name="entry-num"><xsl:value-of select="$thiscolnum"/></xsl:with-param>
        </xsl:call-template>
      </xsl:if>
    </xsl:variable>
    <!-- If we calculated a width, create the width attribute. -->
    <xsl:if test="string-length($widthpercent)>0">
      <xsl:attribute name="width">
        <xsl:value-of select="$widthpercent"/><xsl:text>%</xsl:text>
      </xsl:attribute>
    </xsl:if>
    <xsl:call-template name="flagit"/>
    <xsl:call-template name="start-revflag-parent"/>
    <xsl:call-template name="start-revflag"/>
    <xsl:variable name="revtest">
      <xsl:if test="@rev and not($FILTERFILE='') and ($DRAFT='yes')"> 
        <xsl:call-template name="find-active-rev-flag">               
          <xsl:with-param name="allrevs" select="@rev"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="revtest-row">
      <xsl:if test="../@rev and not($FILTERFILE='') and ($DRAFT='yes')"> 
        <xsl:call-template name="find-active-rev-flag">               
          <xsl:with-param name="allrevs" select="../@rev"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:variable>
    <xsl:choose>
     <xsl:when test="$thiscolnum=$localkeycol and $revtest-row=1">
      <strong><span class="{../@rev}">
<xsl:call-template name="propentry-templates"/>
      </span></strong>
     </xsl:when>
     <xsl:when test="$thiscolnum=$localkeycol and $revtest=1">
      <strong><span class="{@rev}">
<xsl:call-template name="propentry-templates"/>
      </span></strong>
     </xsl:when>
     <xsl:when test="$thiscolnum=$localkeycol">
      <strong>
<xsl:call-template name="propentry-templates"/>
      </strong>
     </xsl:when>
     <xsl:when test="$revtest-row=1">
      <span class="{../@rev}">
<xsl:call-template name="propentry-templates"/>
      </span>
     </xsl:when>
     <xsl:when test="$revtest=1">
      <span class="{@rev}">
<xsl:call-template name="propentry-templates"/>
      </span>
     </xsl:when>
     <xsl:otherwise>
<xsl:call-template name="propentry-templates"/>
     </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="end-revflag"/>
    <xsl:call-template name="end-revflag-parent"/>
  </td><xsl:value-of select="$newline"/>
</xsl:template>

<xsl:template name="propentry-templates">
 <xsl:choose>
  <xsl:when test="*|text()|processing-instruction()">
   <xsl:apply-templates/>
  </xsl:when>
  <xsl:when test="@specentry">
   <xsl:value-of select="@specentry"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>  <!-- nbsp -->
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>

</xsl:stylesheet>
