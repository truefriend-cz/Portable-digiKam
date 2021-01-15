<?xml version="1.0" encoding="UTF-8"?>

<!--

**********************************************
** Convert newlines to HTML breaks template **
**********************************************

This "convertNewlinesToHtmlBreaks" template is a modification of code derived
from the Stack Overflow page https://stackoverflow.com/questions/3309746/
in an answer by user Dimitre Novatchev
https://stackoverflow.com/users/36305/dimitre-novatchev
whose content was released under the CC-BY-SA 4.0 licence.

This derivative is being made available under the GNU GPLv3, as described in the
LICENCE.txt file found in the html5responsive directory of this software work.

This program is distributed in the hope that it will be
useful, but WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
PURPOSE.  See the GNU General Public License for more
details.

-->

<!-- TODO: Work out whether digiKam generates \r\n newline terminators on
Windows, and \r newline terminators on the Mac, and if so then adapt this
template to handle all such cases. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:template name="convertNewlinesToHtmlBreaks">
	<xsl:param name="rawText"/>
	<xsl:choose>
		<xsl:when test="not(contains($rawText, '&#xA;'))">
			<xsl:value-of select="$rawText"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="substring-before($rawText, '&#xA;')"/>
			<br />
			<xsl:call-template name="convertNewlinesToHtmlBreaks">
				<xsl:with-param name="rawText" select="substring-after($rawText, '&#xA;')"/>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template></xsl:stylesheet>
