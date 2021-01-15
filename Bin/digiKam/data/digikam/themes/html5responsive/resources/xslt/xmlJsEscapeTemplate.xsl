<?xml version="1.0" encoding="UTF-8"?>

<!--

******************************
** XML2JSON escape template **
******************************

This escapeTextForJavaScript template is a modification of code derived from
xml2json.xsl which is Copyright (c) 2009, 2019 Jens Duttke and is made available
at https://xml2json.duttke.de/ under the MIT License.

This derivative is being made available under the GNU GPLv3, as described in the
LICENCE.txt file found in the html5responsive directory of this software work.

This program is distributed in the hope that it will be
useful, but WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
PURPOSE.  See the GNU General Public License for more
details.

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<!-- Replace characters which could cause an invalid JS object, by their escape-codes. -->
	<xsl:template name="escapeTextForJavaScript">
		<xsl:param name="text" />
		<xsl:param name="char" select="'\'" />
		<xsl:param name="nextChar" select="substring(substring-after('\/&quot;&#xD;&#xA;&#x9;',$char),1,1)" />

		<xsl:choose>
			<xsl:when test="$char = ''">
				<xsl:value-of select="$text" />
			</xsl:when>

			<xsl:when test="contains($text,$char)">
				<xsl:call-template name="escapeTextForJavaScript">
					<xsl:with-param name="text" select="substring-before($text,$char)" />
					<xsl:with-param name="char" select="$nextChar" />
				</xsl:call-template>
				<xsl:value-of select="concat('\',translate($char,'&#xA;&#xD;&#x9;','nrt'))" />
				<xsl:call-template name="escapeTextForJavaScript">
					<xsl:with-param name="text" select="substring-after($text,$char)" />
					<xsl:with-param name="char" select="$char" />
				</xsl:call-template>
			</xsl:when>

			<xsl:otherwise>
				<xsl:call-template name="escapeTextForJavaScript">
					<xsl:with-param name="text" select="$text" />
					<xsl:with-param name="char" select="$nextChar" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
