<?xml version="1.0" encoding="utf-8"?>

<!--

   $Id: requirements.xsl,v 1.3 2002/05/18 19:02:04 pascal Exp $
   $Log: requirements.xsl,v $
   Revision 1.3  2002/05/18 19:02:04  pascal
   Merged

   Revision 1.2  2002/05/12 19:51:09  pascal
   requirements list automated documentation (fop): stable version

   $Author: pascal $

   This file belongs to the 'Project Architect' and is released under the GNU General Public License (GPL)

   Copyright (C) Pascal Munerot

-->

<!DOCTYPE root [
<!ENTITY backcol "#AABBEE">
]>

<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	version="1.0">

<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:template match="requirements">
<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" reference-orientation="90">

	<fo:layout-master-set>
          <fo:simple-page-master master-name="all" background-color="blue"
		page-height="11.5in" page-width="8.5in"
                 margin-top="1in" margin-bottom="1in"
                 margin-left="0.75in" margin-right="0.75in">
		<fo:region-body margin-top="1in" margin-bottom="0.75in"/>
		<fo:region-before extent="0.75in"/>
		<fo:region-after extent="0.5in"/>
	  </fo:simple-page-master>
	</fo:layout-master-set>

	<fo:page-sequence master-reference="all" format="1">

    <fo:static-content flow-name="xsl-region-before">

<!--
-->
            <fo:block margin-left="0pt" margin-right="0pt" font="bold 14pt Helvetica"
                      space-before="18pt" space-after="6pt"
                      space-before.conditionality="discard" keep-with-next.within-column="always" keep-together.within-column="always"
                      text-align="center" padding="3pt" background-color="&backcol;"
                      border-color="black" border-style="solid" border-width="0.5pt"
                  >The Project Architect - List of software dependencies</fo:block>


            <fo:block text-align="start" font-size="8pt" font-family="serif" line-height="1em + 2pt">
	      <fo:retrieve-marker retrieve-class-name="newpage" retrieve-boundary="page" retrieve-position="first-starting-within-page"/>
<!--              <fo:leader leader-alignment="reference-area" leader-pattern="rule" leader-length="7in"/>-->
	      <fo:retrieve-marker retrieve-class-name="newpage" retrieve-boundary="page" retrieve-position="last-ending-within-page"/>
            </fo:block>
    </fo:static-content>

    <fo:static-content flow-name="xsl-region-after">
       <fo:block text-align="center" font-size="8pt" font-family="serif" line-height="1em + 2pt">- Page <fo:page-number/> -</fo:block>
    </fo:static-content>

    <fo:flow flow-name="xsl-region-body">
         <fo:table space-after.optimum="15pt">
	 <fo:table-column column-width="2.5cm"/> <!-- name column -->
	 <fo:table-column column-width="2cm"/>   <!-- description column -->
	 <fo:table-column column-width="1.3cm"/> <!-- license-type -->
	 <fo:table-column column-width="4cm"/>   <!-- download -->
	 <fo:table-column column-width="1.5cm"/> <!-- min-version -->
	 <fo:table-column column-width="3cm"/>   <!-- build-depend -->
	 <fo:table-column column-width="3cm"/>   <!-- application-depend -->
         <fo:table-header table-omit-header-at-break="false"/>

	 <fo:table-body font-size="8pt"
                        font-family="sans-serif"
                        border-width="0.5pt"
                        border-style="double"
                        border-color="lightblue" background-color="&backcol;"
            >
	    <fo:table-row height="20pt" border-color="black" border-width="0.5pt" border-style="inset">
	      <fo:table-cell padding="3pt" border-color="black" border-width="0.5pt" border-style="solid"><fo:block  writing-mode="tb" font-weight="bold" text-align="start">Name</fo:block></fo:table-cell>
	      <fo:table-cell padding="3pt" border-color="black" border-width="0.5pt" border-style="solid"><fo:block font-weight="bold" text-align="start">Description</fo:block></fo:table-cell>
	      <fo:table-cell padding="3pt" border-color="black" border-width="0.5pt" border-style="solid"><fo:block font-weight="bold" text-align="start">License</fo:block></fo:table-cell>
	      <fo:table-cell padding="3pt" border-color="black" border-width="0.5pt" border-style="solid"><fo:block font-weight="bold" text-align="start">Download</fo:block></fo:table-cell>
	      <fo:table-cell padding="3pt" border-color="black" border-width="0.5pt" border-style="solid"><fo:block font-weight="bold" text-align="start">Minimal version</fo:block></fo:table-cell>
	      <fo:table-cell padding="3pt" border-color="black" border-width="0.5pt" border-style="solid"><fo:block font-weight="bold" text-align="start">Build dependencies</fo:block></fo:table-cell>
	      <fo:table-cell padding="3pt" border-color="black" border-width="0.5pt" border-style="solid"><fo:block font-weight="bold" text-align="start">Application dependencies</fo:block></fo:table-cell>
	    </fo:table-row>

         <xsl:apply-templates select="/requirements/requirement"/>

	 </fo:table-body>
         </fo:table>
         <fo:footnote>
            <fo:footnote-body><fo:block>generated with ANT and FOP</fo:block></fo:footnote-body>
         </fo:footnote>
    </fo:flow>

   </fo:page-sequence>
</fo:root>
</xsl:template>

<xsl:template match="requirement">
x      <fo:table-row height="auto">
        <fo:table-cell padding="3pt" border-color="black" border-width="0.5pt" border-style="solid"><fo:block text-align="start"><xsl:value-of select="@name"/></fo:block></fo:table-cell>
	<fo:table-cell padding="3pt" border-color="black" border-width="0.5pt" border-style="solid"><fo:block text-align="start"><xsl:apply-templates select="./description"/></fo:block></fo:table-cell>
	<fo:table-cell padding="3pt" border-color="black" border-width="0.5pt" border-style="solid"><fo:block text-align="start"><xsl:apply-templates select="./license"/></fo:block></fo:table-cell>
	<fo:table-cell padding="3pt" border-color="black" border-width="0.5pt" border-style="solid"><fo:block text-align="start"><xsl:apply-templates select="./download"/></fo:block></fo:table-cell>
	<fo:table-cell padding="3pt" border-color="black" border-width="0.5pt" border-style="solid"><fo:block text-align="start"><xsl:apply-templates select="./min-version"/></fo:block></fo:table-cell>
	<fo:table-cell padding="3pt" border-color="black" border-width="0.5pt" border-style="solid"><fo:block text-align="start"><xsl:apply-templates select="./build-depend"/></fo:block></fo:table-cell>
	<fo:table-cell padding="3pt" border-color="black" border-width="0.5pt" border-style="solid"><fo:block text-align="start"><xsl:apply-templates select="./application-depend"/></fo:block></fo:table-cell>
      </fo:table-row>
</xsl:template>

<xsl:template match="license-type">
	<fo:block text-align="start">
		<xsl:value-of select="."/>
	</fo:block>
</xsl:template>

<xsl:template match="download">
	<fo:block text-align="start">
		<xsl:value-of select="."/>
	</fo:block>
</xsl:template>

<xsl:template match="description">
	<fo:block text-align="start">
		<xsl:value-of select="."/>
	</fo:block>
</xsl:template>

<xsl:template match="min-version">
	<fo:block text-align="start">
		<xsl:value-of select="."/>
	</fo:block>
</xsl:template>

<xsl:template match="build-depend">
	<fo:block text-align="start">
		<xsl:value-of select="."/>
	</fo:block>
</xsl:template>

<xsl:template match="application-depend">
	<fo:block text-align="start">
		<xsl:value-of select="."/>
	</fo:block>
</xsl:template>


</xsl:stylesheet>

