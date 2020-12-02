<?xml version='1.0'?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fos="http://www.w3.org/xpath-functions/spec/namespace"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="fos xs">

	<xsl:output method="xml" indent="yes"/>

	<!-- This stylesheet takes as input the two function catalogs (XPath and XSLT)
	   and produces a table showing the operand usages for all functions except
	   those where special rules apply. For functions with special rules, a
	   link is generated. -->
	
	<!-- The output is in xmlspec format and is transcluded into the main spec
		using a processing instruction -->

	<xsl:variable name="fos40doc"
                      select="doc('../../xpath-functions-40/src/function-catalog.xml')"/>
	
	<xsl:variable name="functions" as="element(fos:function)*"
                      select="/*/fos:function, $fos40doc/*/fos:function"/>

	<xsl:template match="/">
		<xsl:for-each select="1 to 20">
			<xsl:comment>DO NOT EDIT: GENERATED BY function-streamability.xsl</xsl:comment>
			<xsl:text>&#xa;</xsl:text>
		</xsl:for-each>
		<ulist>
			<xsl:for-each-group select="$functions[not(@prefix = 'op')]" group-by="concat(@prefix, ':', @name)">
				<xsl:sort select="(@prefix, 'fn')[1]"/>
				<xsl:sort select="lower-case(@name)"/>
				<xsl:apply-templates select="."/>
			</xsl:for-each-group>	
		</ulist>	
	</xsl:template>

	<xsl:template match="fos:function[fos:properties/fos:property='special-streaming-rules']">
		<item><p>
			<code><xsl:value-of select="(@prefix, 'fn')[1], ':', @name" separator=""/></code>
			<xsl:text> &#x2013; See </xsl:text>
			<specref ref="streamability-{(@prefix, 'fn')[1]}-{@name}"/>
		</p></item>
	</xsl:template>
	
	<xsl:template match="fos:function">
		<xsl:apply-templates select="fos:signatures/fos:proto"/>
	</xsl:template>
	
	<xsl:template match="fos:proto">
		<item>
			<p>
				<code>
				<xsl:value-of select="(../../@prefix, 'fn')[1], ':', ../../@name, '('" separator=""/>
				<xsl:for-each select="fos:arg">
					<xsl:if test="position() gt 1">, </xsl:if>
					<xsl:choose>
						<xsl:when test="@usage">
							<xsl:value-of select="upper-case(substring(@usage,1,1))"/>
						</xsl:when>
						<xsl:otherwise>A</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				<xsl:text>)</xsl:text>
				</code>
			</p>
		</item>
	</xsl:template>
	
	<xsl:template match="fos:proto[following-sibling::*/fos:arg/@default]">
		<item>
			<p>
				<code>
					<xsl:value-of select="(../../@prefix, 'fn')[1], ':', ../../@name, '('" separator=""/>
					<xsl:for-each select="fos:arg">
						<xsl:if test="position() gt 1">, </xsl:if>
						<xsl:value-of select="'x'"/>
					</xsl:for-each>
					<xsl:text>)</xsl:text>
				</code>
			    
			    <xsl:text> &#x2013; Equivalent to </xsl:text>
				<code>
					<xsl:value-of select="(../../@prefix, 'fn')[1], ':', ../../@name, '('" separator=""/>
					<xsl:for-each select="following-sibling::*/fos:arg">
						<xsl:if test="position() gt 1">, </xsl:if>
						<xsl:value-of select="(@default, 'x')[1]"/>
					</xsl:for-each>
					<xsl:text>)</xsl:text>
			    </code>
			</p>
		</item>
	</xsl:template>
		
		
</xsl:stylesheet>
