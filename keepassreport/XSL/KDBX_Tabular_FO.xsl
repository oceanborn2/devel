<?xml version="1.0"?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                exclude-result-prefixes="fo" xsi:schemaLocation="http://www.w3.org/1999/XSL/Format fop.xsd">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <xsl:variable name="fieldsOrder">
        <field name="UserName" order="1"/>
        <field name="Password" order="2"/>
        <field name="URL" order="3"/>
    </xsl:variable>

    <!-- name of template group for filtering out its entries -->
    <xsl:variable name="tg" select="/KeePassFile/Meta/EntryTemplatesGroup/text()"/>

    <xsl:template match="/">
        <fo:root>
            <fo:layout-master-set>
                <fo:simple-page-master master-name="std_10x15" page-height="100mm" page-width="150mm" margin-left="5mm"
                                       margin-right="5mm" margin-top="10mm" margin-bottom="10mm" direction="ltr"
                                       reference-orientation="0">
                    <fo:region-body margin="0mm"/>
                </fo:simple-page-master>
            </fo:layout-master-set>
            <xsl:apply-templates select=".//Entry">
                <xsl:sort
                        select="string-join(../ancestor-or-self::Group[local-name(..) != 'Root']/Name/text(), ' / ')"/>
            </xsl:apply-templates>
        </fo:root>
    </xsl:template>

    <xsl:template match="text()"/>

    <xsl:template match="Entry[local-name(..)!='History' and ../Name/text()!=$tg]">
        <!--<xsl:message><xsl:value-of select=".//String[Key/text()]"/></xsl:message>-->
        <fo:page-sequence master-reference="std_10x15">
            <fo:flow flow-name="xsl-region-body" font-size="11" font-family="Arial" font-style="normal"
                     display-align="center">

                <fo:block margin="0" font-size="14" display-align="center" font-family="Arial" font-weight="bold"
                          space-after="5mm">
                    <xsl:value-of select="String[Key/text()='Title']/Value/text()"/>
                </fo:block>

                <xsl:variable name="url" select="String[Key/text()='URL']/Value/text()"/>
                <xsl:choose>
                    <xsl:when test="$url != ''">
                        <fo:block>
                            <fo:basic-link color="blue" external-destination="url({$url})">
                                <fo:block text-decoration="underline" margin="0" font-size="14" display-align="center"
                                          font-family="Arial"
                                          color="blue"
                                          font-weight="bold"
                                          space-after="5mm">
                                    <fo:inline border-after-width="1pt" border-after-style="solid"/>
                                    <xsl:value-of select="$url"/>
                                </fo:block>
                            </fo:basic-link>
                        </fo:block>
                    </xsl:when>
                </xsl:choose>

                <fo:block margin="0.05cm">
                    <fo:table table-layout="fixed" keep-with-next="always">
                        <fo:table-column column-number="1" column-width="proportional-column-width(25)"/>
                        <fo:table-column column-number="2" column-width="proportional-column-width(75)"/>
                        <fo:table-header>
                            <fo:table-row>  <!--group -->
                                <fo:table-cell border="solid 1px black" background-color="black"
                                               text-align="left"
                                               font-weight="bold"><!--inline-progression-dimension="30mm">-->
                                    <fo:block color="white">Groupe</fo:block>
                                </fo:table-cell>
                                <fo:table-cell border="solid 1px black" background-color="white"
                                               text-align="left" font-weight="bold">
                                    <fo:block color="black">
                                        <xsl:value-of
                                                select="string-join(../ancestor-or-self::Group[local-name(..) != 'Root']/Name/text(), ' / ')"/>
                                    </fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                            <fo:table-row> <!-- Entry -->
                                <fo:table-cell border="solid 1px black" background-color="black"
                                               text-align="left" font-weight="bold">
                                    <fo:block color="white">Titre</fo:block>
                                </fo:table-cell>
                                <fo:table-cell border="solid 1px black" background-color="white"
                                               text-align="left" font-weight="bold">
                                    <fo:block color="black">
                                        <xsl:for-each select="String[Key/text()='Title']">
                                            <xsl:value-of select="Value/text()"/>
                                        </xsl:for-each>
                                    </fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </fo:table-header>
                        <fo:table-body>
                            <xsl:for-each select="./String">
                                <xsl:sort select="./Key/text()" data-type="text"/>
                                <xsl:variable name="key" select="./Key/text()"/>
                                <xsl:variable name="val" select="./Value/text()"/>
                                <xsl:choose>
                                    <xsl:when test="$key != 'Title' and $key != 'Notes' and $key != 'URL'">
                                        <fo:table-row>
                                            <fo:table-cell border="solid 1px black"
                                                           text-align="left">
                                                <fo:block>
                                                    <xsl:value-of select="$key"/>
                                                </fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell border="solid 1px black"
                                                           text-align="left">
                                                <fo:block>
                                                    <xsl:value-of select="$val"/>
                                                </fo:block>
                                            </fo:table-cell>
                                        </fo:table-row>
                                    </xsl:when>
                                </xsl:choose>
                                <fo:table-row visibility="hidden">
                                    <fo:table-cell>
                                        <fo:block></fo:block>
                                    </fo:table-cell>
                                </fo:table-row>
                            </xsl:for-each>
                        </fo:table-body>
                    </fo:table>

                    <xsl:variable name="notes" select="String[Key/text()='Notes']/Value/text()"/>

                    <xsl:choose>
                        <xsl:when test="$notes != ''">
                            <fo:table keep-together.within-page="always" page-break-before="auto" space-before="4mm" table-layout="fixed" border="solid 1px black" font-size="9" auto-restore="true"> <!--keep-together.within-line="always"-->
                                <fo:table-header>
                                    <fo:table-row page-break-before="avoid">
                                        <fo:table-cell border="solid 1px black" background-color="black"
                                                       text-align="left"
                                                       font-weight="bold">
                                            <fo:block color="white">Notes</fo:block>
                                        </fo:table-cell>
                                    </fo:table-row>
                                </fo:table-header>
                                <fo:table-body>
                                    <xsl:for-each select="tokenize($notes,'\n')">
                                        <fo:table-row keep-with-next="always" page-break-inside="avoid">
                                            <fo:table-cell>
                                                <fo:block>
                                                    <xsl:value-of select="."/>
                                                </fo:block>
                                            </fo:table-cell>
                                        </fo:table-row>
                                    </xsl:for-each>
                                    <fo:table-row>
                                        <fo:table-cell visibility="hidden">
                                            <fo:block></fo:block>
                                        </fo:table-cell>
                                    </fo:table-row>
                                </fo:table-body>
                            </fo:table>
                        </xsl:when>
                    </xsl:choose>

                </fo:block>
            </fo:flow>
        </fo:page-sequence>
    </xsl:template>


</xsl:stylesheet>
