<?xml version="1.0" encoding="iso-8859-1"?>

<!--

   $Id: Changelog.xsl,v 1.1 2002/05/28 21:03:31 munerot Exp $
   $Log: Changelog.xsl,v $
   Revision 1.1  2002/05/28 21:03:31  munerot
   moved these files to this directory to improve overall documentation consistency

   Revision 1.2  2002/05/18 19:21:24  pascal
   Commit for sourceforge cvs import

   Revision 1.2  2002/05/12 19:51:09  pascal
   requirements list automated documentation (fop): stable version

   $Author: munerot $

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

<xsl:template match="ChangeLog">
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

            <fo:block margin-left="0pt" margin-right="0pt" font="bold 14pt Helvetica"
                      space-before="18pt" space-after="6pt"
                      space-before.conditionality="discard" keep-with-next.within-column="always" keep-together.within-column="always"
                      text-align="center" padding="3pt" background-color="&backcol;"
                      border-color="black" border-style="solid" border-width="0.5pt"
                  >The Project Architect - Major changes list</fo:block>

            <fo:block text-align="start" font-size="8pt" font-family="serif" line-height="1em + 2pt">
	      <fo:retrieve-marker retrieve-class-name="newpage" retrieve-boundary="page" retrieve-position="first-starting-within-page"/>
	      <fo:retrieve-marker retrieve-class-name="newpage" retrieve-boundary="page" retrieve-position="last-ending-within-page"/>
            </fo:block>
    </fo:static-content>

    <fo:static-content flow-name="xsl-region-after">
       <fo:block text-align="center" font-size="8pt" font-family="serif" line-height="1em + 2pt">- Page <fo:page-number/> -</fo:block>
    </fo:static-content>

    <fo:flow flow-name="xsl-region-body">
	       	<xsl:apply-templates select="Change"/>
    </fo:flow>

   </fo:page-sequence>
</fo:root>
</xsl:template>

<xsl:template match="Change">
	<fo:list-block space-before="6pt" space-after="6pt" provisional-distance-between-starts="0.25in" provisional-label-separation="0in" space-after.optimum="3pt">
	<fo:list-item>
	<fo:list-item-label   end-indent="label-end()"><fo:block font-family="ZapfDingbats">â</fo:block></fo:list-item-label>
	 <fo:list-item-body start-indent="body-start()"><fo:block><xsl:value-of select="@date"/>:<xsl:value-of select="@author"/> - <xsl:value-of select="@email"/></fo:block></fo:list-item-body>
 	</fo:list-item>
        </fo:list-block>

       <fo:list-block space-before="6pt" space-after="6pt" provisional-distance-between-starts="0.25in" provisional-label-separation="0.25in" space-after.optimum="3pt"
           font-size="10pt">
		<xsl:apply-templates select="Item"/>
       </fo:list-block>
</xsl:template>

<xsl:template match="Item">
	<fo:list-item>
	 <fo:list-item-label  end-indent="label-end()"><fo:block>-</fo:block></fo:list-item-label>
	 <fo:list-item-body start-indent="body-start()"><fo:block><xsl:value-of select="."/></fo:block></fo:list-item-body>
	</fo:list-item>
</xsl:template>

</xsl:stylesheet>

