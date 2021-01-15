<?xml version="1.0" encoding="UTF-8" ?>

<!--
* ============================================================
*
* This file is a part of a digiKam custom HTML gallery theme.
* https://www.digikam.org
*
* Date        : 2019-11-17
* Description : An HTML gallery theme based on HTML5, CSS3,
* UTF-8 and the PhotoSwipe utility.
*
* Created in 2019 by Bobulous <https://www.bobulous.org.uk>,
* based on a heavily modified derivative of the Elegant theme
* which was created in 2007 by Wojciech Jarosz
* <jiri at boha dot cz>.
*
* This program is free software, made available under the GNU
* GPLv3 as described in the LICENCE.txt file found in the
* html5responive directory of this program.
*
* This program is distributed in the hope that it will be
* useful, but WITHOUT ANY WARRANTY; without even the implied
* warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
* PURPOSE.  See the GNU General Public License for more
* details.
*
* ============================================================
-->

<xsl:transform version="1.0"
			   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
			   xmlns:exsl="http://exslt.org/common"
			   xmlns:date="http://exslt.org/dates-and-times"
			   extension-element-prefixes="exsl date">
	
	<xsl:import href="resources/xslt/xmlJsEscapeTemplate.xsl"/>
	<xsl:import href="resources/xslt/convertNewlinesToHtmlBreaksTemplate.xsl"/>
	
	<xsl:output method="html"
			 indent="yes" 
			 encoding="utf-8" 
			 doctype-system="about:legacy-compat" />
	
	
	<!-- ##################### VARIABLE INITILIZATION ######################### -->
	<!-- Initialize some useful variables -->
	<xsl:variable name="theme" select="'grey'" />
	<xsl:variable name="outerBorder" select="boolean(0)" />
	<xsl:variable name="resizeSpeed" select="10" />
	<xsl:variable name="maxOpacity" select="80" />
	<xsl:variable name="navType" select="1" />
	<xsl:variable name="autoResize" select="boolean(1)" />
	<xsl:variable name="doAnimations" select="boolean(1)" />
	<xsl:variable name="showNavigation" select="boolean(1)" />
	<xsl:variable name="numCollections" select="count(collections/collection)"/>
	
	
<!-- ##################### STARTING POINT ################################# -->
<!--
Determines if we need to create a collectionListPage or just one
collectionStartPage.
-->
<xsl:template match="/">
	<xsl:choose>
		<xsl:when test="$numCollections &gt; 1">
			<xsl:call-template name="collectionListPage"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:for-each select="collections/collection">
				<xsl:call-template name="generateDetailPages">
					<xsl:with-param name="soleCollection">true</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="collectionPage">
					<xsl:with-param name="pageFilename">index.html</xsl:with-param>
					<xsl:with-param name="pageNum" select="0"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
<!-- ##################### END STARTING POINT ############################# -->

<!-- ##################### COLLECTION LIST PAGE GENERATION ################ -->
<!--
If more than one collection was selected for export then a collectionListPage
is generated which provides a list of all the individual collections.
-->
<xsl:template name="collectionListPage">
	<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<meta name="generator" content="digiKam"/>
		<title><xsl:value-of select="$i18nCollectionList"/></title>
		<link rel="stylesheet" type="text/css" media="screen">
			<xsl:attribute name="href">html5responsive/resources/css/<xsl:value-of select="$style"/></xsl:attribute>
		</link>
	</head>
	<body class="collectionListPage">
		<header>
			<h1><xsl:value-of select="$i18nCollectionList"/></h1>
		</header>
		<main>
			<ul class="collectionList">
				<xsl:for-each select="collections/collection">
					<xsl:call-template name="generateDetailPages">
						<xsl:with-param name="soleCollection">false</xsl:with-param>
					</xsl:call-template>
					<xsl:variable name="imageAspect">
						<xsl:call-template name="aspectLabel">
							<xsl:with-param name="imageWidth" select="image[1]/thumbnail/@width"/>
							<xsl:with-param name="imageHeight" select="image[1]/thumbnail/@height"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:variable name="altName" select="name"/>
					<li class="{$imageAspect}">
						<figure>
						<a href="{fileName}.html" class="thumbnailLink">
							<!-- Use first image as collection image -->
							<img src="{fileName}/{image[1]/thumbnail/@fileName}" width="{image[1]/thumbnail/@width}" height="{image[1]/thumbnail/@height}" alt="{$altName}"/>
						</a>
						<figcaption><a href="{fileName}.html"><xsl:value-of select="name"/></a></figcaption>
						</figure>
					</li>
					<exsl:document href="{fileName}.html"
					method="html"
					indent="yes" 
					encoding="utf-8" 
					doctype-system="about:legacy-compat">
						<xsl:call-template name="collectionPage">
							<xsl:with-param name="pageFilename"><xsl:value-of select="fileName"/>.html</xsl:with-param>
							<xsl:with-param name="pageNum" select="0"/>
						</xsl:call-template>
					</exsl:document>
				</xsl:for-each>
			</ul>
		</main>
		<!-- /content -->
		<xsl:if test="$author != ''">
			<footer>
				<xsl:call-template name="copyrightNotice"/>
			</footer>
		</xsl:if>
	</body>
	</html>
</xsl:template>
<!-- ##################### END COLLECTION LIST PAGE GENERATION ############ -->

<xsl:template name="aspectLabel">
	<xsl:param name="imageWidth"/>
	<xsl:param name="imageHeight"/>
	<xsl:choose>
		<xsl:when test="$imageWidth &gt; $imageHeight">
			<xsl:text>landscape</xsl:text>
		</xsl:when>
		<xsl:when test="$imageWidth &lt; $imageHeight">
			<xsl:text>portrait</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>square</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="copyrightNotice">
	<div class="copyright" lang="en">
		<xsl:text>All Images Copyright © </xsl:text>
		<xsl:value-of select="date:year()"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="$author"/>
	</div>
</xsl:template>


<!-- ##################### COLLECTION DETAIL PAGE GENERATION ################## -->
<!--
Each photo in a collection has a detail page which displays only that photo and
data related to that photo (title, description, EXIF data, etc). This template
generates all detail pages for the current collection.
-->
<xsl:template name="generateDetailPages">
	<xsl:param name="soleCollection"/>
	<xsl:variable name="folder" select='fileName'/>
	<xsl:for-each select="image">
		<xsl:variable name="photoIndex" select="position() - 1"/>
		<xsl:variable name="pageIndex" select="floor((position() - 1) div $pageSize)"/>
		<!-- TODO: MODIFY THIS SO THAT EVERY PHOTO POINTS TO THE COLLECTION THUMBNAIL PAGE WHICH HOLDS IT (not just to the first thumbnail page) -->
		<xsl:variable name="pageFilename">
			<xsl:choose>
				<xsl:when test="$soleCollection = 'true' and $pageIndex = 0">
					<xsl:text>../index.html</xsl:text>
				</xsl:when>
				<xsl:otherwise><xsl:text>../</xsl:text><xsl:value-of select="$folder"/>
						<xsl:choose>
							<xsl:when test="$pageIndex = 0">
								<xsl:text>.html</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>_</xsl:text><xsl:value-of select="$pageIndex"/><xsl:text>.html</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<exsl:document href='{$folder}/{full/@fileName}.html'
				method="html"
				indent="yes" 
				encoding="utf-8" 
				doctype-system="about:legacy-compat">
			<xsl:call-template name="imagePage">
				<xsl:with-param name="indexPage"><xsl:value-of select="$pageFilename"/></xsl:with-param>
			</xsl:call-template>
		</exsl:document>
	</xsl:for-each>
</xsl:template>
<!-- ##################### END COLLECTION DETAIL PAGE GENERATION ############## -->


<!-- ##################### COLLECTION PAGE GENERATION ##################### -->
<!--
A page of thumbnails for a sigle collection.
If there are too many thumbnails to fit on one page then the content is split
up into multiple pages.
-->
<xsl:template name="collectionPage">
	<xsl:param name="pageNum"/>
	<xsl:param name="pageFilename"/>
	<!-- <xsl:variable name="pageFilename" select="concat(fileName, '_', $pageNum, '.html')"/> -->
	<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<meta name="generator" content="digiKam"/>
		<title><xsl:value-of select="name"/></title>
		<link rel="stylesheet" type="text/css" media="screen">
			<xsl:attribute name="href">html5responsive/resources/css/<xsl:value-of select="$style"/></xsl:attribute>
		</link>
		<xsl:if test="$usePhotoSwipe = 'true'">
			<xsl:call-template name="photoSwipeStylesheets"/>
			<xsl:call-template name="photoSwipeJavaScriptLibraries"/>
		</xsl:if>
	</head>
	<body class="collectionPage">
	<xsl:variable name="numPages" select="ceiling(count(image) div $pageSize)"/>
	<xsl:variable name="folder" select='fileName'/>
	<xsl:variable name="pageName" select="name"/>

	<header>
		<div id="pageTitleAndPagination">
			<h1>
				<xsl:value-of select="name"/>
			</h1>
			<xsl:if test="$numCollections &gt; 1 or $paginationLocation = 'top' or $paginationLocation = 'both'">
				<nav class="topOfPage">
					<xsl:if test="$numCollections &gt; 1">
						<p class="upLink albumListLink">
							<a href="index.html">
								<xsl:value-of select="$i18nCollectionList"/>
							</a>
						</p>
					</xsl:if>				
					<xsl:if test="$paginationLocation = 'top' or $paginationLocation = 'both'">
						<xsl:call-template name="pagination">
							<xsl:with-param name="numPages" select="$numPages"/>
							<xsl:with-param name="pageNum" select="$pageNum"/>
							<xsl:with-param name="paginationMode" select="$paginationModeTop"/>
						</xsl:call-template>
					</xsl:if>
				</nav>
			</xsl:if>
		</div>
	</header>
	<main>
		<ol class="imageList">
			<!-- Add thumbnails and links to all images for the current page. -->
			<xsl:for-each select="image[(position() &gt;= ($pageNum * $pageSize) + 1) and (position() &lt;= $pageSize + ($pageSize * $pageNum))]">
				<xsl:variable name="photoIndex" select="$pageSize * $pageNum + position() - 1"/>
				<xsl:variable name="jiggleHooks">
					<xsl:if test="$addJiggle = 'true'">
						<xsl:variable name="mod2" select="$photoIndex mod 2"/>
						<xsl:variable name="mod3" select="$photoIndex mod 3"/>
						<xsl:variable name="mod5" select="$photoIndex mod 5"/>
						<xsl:text>mod2val</xsl:text>
						<xsl:value-of select="$mod2"/>
						<xsl:text> mod3val</xsl:text>
						<xsl:value-of select="$mod3"/>
						<xsl:text> mod5val</xsl:text>
						<xsl:value-of select="$mod5"/>
					</xsl:if>
				</xsl:variable>
				<xsl:variable name="imageAspect">
					<xsl:call-template name="aspectLabel">
						<xsl:with-param name="imageWidth" select="thumbnail/@width"/>
						<xsl:with-param name="imageHeight" select="thumbnail/@height"/>
					</xsl:call-template>
				</xsl:variable>
				<li class="{$imageAspect} {$jiggleHooks}">
					<figure>
						<xsl:variable name="onClickAction">
							<xsl:if test="$usePhotoSwipe = 'true'">
								<xsl:text>openImageInPhotoSwipe(</xsl:text>
								<xsl:value-of select="$photoIndex"/>
								<xsl:text>); return false;</xsl:text>
							</xsl:if>
						</xsl:variable>
						<a class="thumbnailLink" href="{$folder}/{full/@fileName}.html" id="collectionPhotoIndex_{$photoIndex}" onclick="{$onClickAction}">
							<img src="{$folder}/{thumbnail/@fileName}" width="{thumbnail/@width}" height="{thumbnail/@height}" alt="{title}"/>
						</a>
						<figcaption>
							<p class="imageTitle"><xsl:value-of select="title"/></p>
							<xsl:if test="date != ''">
								<p class="imageDate">
									<time datetime="{date}">
										<xsl:value-of select="date"/>
									</time>
								</p>
							</xsl:if>
							<xsl:if test="description != ''">
								<p class="imageDescription">
									<xsl:call-template name="convertNewlinesToHtmlBreaks">
										<xsl:with-param name="rawText" select="description"/>
									</xsl:call-template>
								</p>
							</xsl:if>
						</figcaption>
					</figure>
				</li>
			</xsl:for-each>
		</ol>		
	</main>
	<xsl:if test="$paginationLocation = 'bottom' or $paginationLocation = 'both' or $author != ''">
		<footer>
			<div class="paginationAndCopyright">
				<xsl:if test="($paginationLocation = 'bottom') or ($paginationLocation = 'both')">
					<nav class="bottomOfPage">
						<xsl:call-template name="pagination">
							<xsl:with-param name="numPages" select="$numPages"/>
							<xsl:with-param name="pageNum" select="$pageNum"/>
							<xsl:with-param name="paginationMode" select="$paginationModeBottom"/>
						</xsl:call-template>
					</nav>
				</xsl:if>
				<xsl:if test="$author != ''">
					<xsl:call-template name="copyrightNotice"/>
				</xsl:if>
			</div>
		</footer>
	</xsl:if>
	
	<xsl:if test="$usePhotoSwipe = 'true'">
		<xsl:call-template name="photoSwipeDomElements"/>
		<xsl:call-template name="photoSwipeJavaScriptInitialisation">
			<xsl:with-param name="numPages" select="$numPages"/>
			<xsl:with-param name="pageNum" select="$pageNum"/>
			<xsl:with-param name="folder" select="$folder"/>
		</xsl:call-template>
	</xsl:if>
	</body>
	</html>
	<xsl:if test="$pageNum = 0">
		<!-- Generate all subsequent collection pages. -->
		<xsl:call-template name="collectionPages"/>
	</xsl:if>
</xsl:template>
<!-- ##################### END COLLECTION PAGE GENERATION ################# -->


<!-- ##################### PHOTOSWIPE COMPONENT GENERATION ###################### -->
<!--
Generates JavaScript and object data required by the PhotoSwipe software.
-->

<xsl:template name="photoSwipeStylesheets">
	<link rel="stylesheet" href="html5responsive/resources/css/photoswipe.css" type="text/css" media="screen"/>
	<link rel="stylesheet" href="html5responsive/resources/css/default-skin/default-skin.css" type="text/css" media="screen"/>
</xsl:template>

<xsl:template name="photoSwipeDomElements">
	<!-- Root element of PhotoSwipe. Must have class pswp. -->
	<div class="pswp" tabindex="-1" role="dialog" aria-hidden="true">
		<!-- Background of PhotoSwipe. 
			It's a separate element as animating opacity is faster than rgba(). -->
		<div class="pswp__bg"></div>
		<!-- Slides wrapper with overflow:hidden. -->
		<div class="pswp__scroll-wrap">
			<!-- Container that holds slides. 
				PhotoSwipe keeps only 3 of them in the DOM to save memory.
				Don't modify these 3 pswp__item elements, data is added later on. -->
			<div class="pswp__container">
				<div class="pswp__item"></div>
				<div class="pswp__item"></div>
				<div class="pswp__item"></div>
			</div>
			<!-- Default (PhotoSwipeUI_Default) interface on top of sliding area. Can be changed. -->
			<div class="pswp__ui pswp__ui--hidden">
				<div class="pswp__top-bar">
					<!--  Controls are self-explanatory. Order can be changed. -->
					<div class="pswp__counter"></div>
					<button class="pswp__button pswp__button--close" title="Close (Esc)"></button>
					<button class="pswp__button pswp__button--share" title="Share"></button>
					<button class="pswp__button pswp__button--fs" title="Toggle fullscreen"></button>
					<button class="pswp__button pswp__button--zoom" title="Zoom in/out"></button>
					<!-- Preloader demo https://codepen.io/dimsemenov/pen/yyBWoR -->
					<!-- element will get class pswp__preloader_active when preloader is running -->
					<div class="pswp__preloader">
						<div class="pswp__preloader__icn">
						<div class="pswp__preloader__cut">
							<div class="pswp__preloader__donut"></div>
						</div>
						</div>
					</div>
				</div>
				<div class="pswp__share-modal pswp__share-modal--hidden pswp__single-tap">
					<div class="pswp__share-tooltip"></div> 
				</div>
				<button class="pswp__button pswp__button--arrow--left" title="Previous (arrow left)">
				</button>
				<button class="pswp__button pswp__button--arrow--right" title="Next (arrow right)">
				</button>
				<div class="pswp__caption">
					<div class="pswp__caption__center"></div>
				</div>
			</div>
		</div>
	</div>
</xsl:template>

<xsl:template name="photoSwipeJavaScriptLibraries">
	<script src="html5responsive/resources/js/photoswipe.min.js"/>
	<script src="html5responsive/resources/js/photoswipe-ui-default.min.js"/>
</xsl:template>

<xsl:template name="photoSwipeJavaScriptInitialisation">
	<xsl:param name="numPages"/>
	<xsl:param name="pageNum"/>
	<xsl:param name="folder"/>
	<script>
		<xsl:text>
var pswpElement = document.querySelectorAll('.pswp')[0];

// build items array
var items = [</xsl:text>
		<xsl:for-each select="image">
			<xsl:text>{</xsl:text>
			<xsl:text>src: "</xsl:text><xsl:call-template name="escapeTextForJavaScript">
				<xsl:with-param name="text" select="$folder"/>
			</xsl:call-template><xsl:text>/</xsl:text><xsl:call-template name="escapeTextForJavaScript">
				<xsl:with-param name="text" select="full/@fileName"/>
			</xsl:call-template><xsl:text>",</xsl:text>
			<xsl:text>w: </xsl:text><xsl:value-of select="full/@width"/><xsl:text>,</xsl:text>
			<xsl:text>h: </xsl:text><xsl:value-of select="full/@height"/><xsl:text>,</xsl:text>
			<xsl:text>title: "</xsl:text><xsl:call-template name="escapeTextForJavaScript">
				<xsl:with-param name="text" select="title"/>
			</xsl:call-template><xsl:text>",</xsl:text>
			<xsl:text>description: "</xsl:text><xsl:call-template name="escapeTextForJavaScript">
				<xsl:with-param name="text" select="description"/>
			</xsl:call-template><xsl:text>",</xsl:text>
			<xsl:text>detailPage: "</xsl:text><xsl:call-template name="escapeTextForJavaScript">
				<xsl:with-param name="text">
					<xsl:value-of select="$folder"/><xsl:text>/</xsl:text><xsl:value-of select="full/@fileName"/><xsl:text>.html</xsl:text>
				</xsl:with-param>
			</xsl:call-template><xsl:text>"</xsl:text>
			<!-- TODO: Work out whether there's an elegant way to avoid writing an unwanted comma at the very end of the list. -->
			<xsl:text>},</xsl:text>
		</xsl:for-each>
	<xsl:text>];

// Define functions related to PhotoSwipe module.

function openImageInPhotoSwipe(photoIndex) {
	var options, gallery;
	// Initializes and opens PhotoSwipe (at the specified photo).
	options = {
		// optionName: 'option value'
		// for example:
		index: photoIndex, // start at selected photo
		addCaptionHTMLFn: photoCaptionGenerator,
		shareEl: </xsl:text><xsl:value-of select="$photoSwipeShowSharingButton" /><xsl:text>,
		bgOpacity: </xsl:text><xsl:value-of select="$photoSwipeBackgroundOpacity" /><xsl:text> / 10
	};
	gallery = new PhotoSwipe(pswpElement, PhotoSwipeUI_Default, items, options);
	gallery.init();
}

var photoCaptionGenerator = function(item, captionEl, isFake) {
	var html;
	if(!item.title &amp;&amp; !item.description &amp;&amp; !item.detailPage) {
		captionEl.children[0].innerHTML = '';
		return false;
	}
	html =  "&lt;div class=\"galleryPhotoCaption\"&gt;";
	if (item.title) {
		html += "&lt;p class=\"galleryPhotoTitle\"&gt;" + item.title.replace(/(?:\r\n|\r|\n)/g, '&lt;br /&gt;') + "&lt;/p&gt;";
	}
	if (item.description) {
		html += "&lt;p class=\"galleryPhotoDescription\"&gt;" + item.description.replace(/(?:\r\n|\r|\n)/g, '&lt;br /&gt;') + "&lt;/p&gt;";
	}
	if (item.detailPage) {
	html += "&lt;p class=\"galleryFullDetailsLink\"&gt;&lt;a href=\"" + item.detailPage + "\"&gt;</xsl:text><xsl:value-of select="$i18nOriginalImage"/><xsl:text>&lt;/a&gt;&lt;/p&gt;";
	}
	html += "&lt;/div&gt;";
	captionEl.children[0].innerHTML = html;
	return true;
}

// This photoswipeParseHash function was taken from the code provided by Dimitry
// Semenov at https://photoswipe.com/documentation/getting-started.html
var photoswipeParseHash = function() {
	var hash = window.location.hash.substring(1),
	params = {};

	if(hash.length &lt; 5) {
		return params;
	}

	var vars = hash.split('&amp;');
	for (var i = 0; i &lt; vars.length; i++) {
		if(!vars[i]) {
			continue;
		}
		var pair = vars[i].split('=');  
		if(pair.length &lt; 2) {
			continue;
		}           
		params[pair[0]] = pair[1];
	}

	if(params.gid) {
		params.gid = parseInt(params.gid, 10);
	}

	return params;
};

// If a PhotoSwipe history URL has been used then open PhotoSwipe directly at
// the specified photo index.
var hashData = photoswipeParseHash();
if(hashData.pid &amp;&amp; hashData.gid) {
	openImageInPhotoSwipe(hashData.pid);
}
</xsl:text>
	</script>
</xsl:template>
<!-- ##################### END PHOTOSWIPE COMPONENT GENERATION ################## -->


<!-- ##################### PAGINATION LINK GENERATATION ################### -->
<xsl:template name="pagination">
	<xsl:param name="numPages"/>
	<xsl:param name="pageNum"/>
	<xsl:param name="paginationMode"/>
	<xsl:if test="$numPages &gt; 1">
		<div class="pagination">
			<xsl:choose>
				<xsl:when test="number($pageNum) = 0">
					<p class="previousLink disabled">
						<xsl:value-of select="$i18nPrevious"/>
					</p>
				</xsl:when>
				<xsl:otherwise>
					<p class="previousLink">
						<a>
							<xsl:attribute name="href">
								<xsl:call-template name="pageLink">
									<xsl:with-param name="collectionFilename" select="fileName"/>
									<xsl:with-param name="pageNum" select="number($pageNum)-1"/>
								</xsl:call-template>
							</xsl:attribute>
							<xsl:value-of select="$i18nPrevious"/>
						</a>
					</p>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="$paginationMode = 'fullList'">
					<ol class="pageNumbersList">
						<xsl:call-template name="pagination.for.loop">
							<xsl:with-param name="i" select="0"/>
							<xsl:with-param name="count" select="$numPages"/>
							<xsl:with-param name="currentPage" select="$pageNum"/>
						</xsl:call-template>
					</ol>
				</xsl:when>
				<xsl:when test="$paginationMode = 'currentOfTotal'">
					<xsl:call-template name="currentPageOfTotal">
						<xsl:with-param name="count" select="$numPages"/>
						<xsl:with-param name="currentPage" select="$pageNum"/>							
					</xsl:call-template>
				</xsl:when>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="number($pageNum) = number($numPages)-1">
					<p class="nextLink disabled">
						<xsl:value-of select="$i18nNext"/>
					</p>
				</xsl:when>
				<xsl:otherwise>
					<p class="nextLink">
						<a>
							<xsl:attribute name="href">
								<xsl:call-template name="pageLink">
									<xsl:with-param name="collectionFilename" select="fileName"/>
									<xsl:with-param name="pageNum" select="number($pageNum)+1"/>
								</xsl:call-template>
							</xsl:attribute>
							<xsl:value-of select="$i18nNext"/>
						</a>
					</p>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:if>
</xsl:template>

<!-- For loop used to generate pagination links -->
<xsl:template name="pagination.for.loop">
	<xsl:param name="i"/>
	<xsl:param name="count"/>
	<xsl:param name="currentPage"/>
	
	<xsl:if test="$i &lt; $count">
		<xsl:choose>
			<xsl:when test="number($currentPage) = $i">
				<li class="pageNumber current"><xsl:value-of select="number($i)+1"/></li>
			</xsl:when>
			<xsl:otherwise>
				<li class="pageNumber">
					<a>
						<xsl:attribute name="href">
							<xsl:call-template name="pageLink">
								<xsl:with-param name="collectionFilename" select="fileName"/>
								<xsl:with-param name="pageNum" select="$i"/>
							</xsl:call-template>
						</xsl:attribute>
						<xsl:value-of select="number($i)+1"/>
					</a>
				</li>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:call-template name="pagination.for.loop">
			<xsl:with-param name="i" select="$i + 1"/>
			<xsl:with-param name="count" select="$count"/>
			<xsl:with-param name="currentPage" select="$currentPage"/>
		</xsl:call-template>
	</xsl:if>
</xsl:template>

<!-- Template which prints out the html url for a particular page -->
<xsl:template name="pageLink">
	<xsl:param name="collectionFilename"/>
	<xsl:param name="pageNum"/>
	<xsl:choose>
		<xsl:when test="($numCollections &gt; 1) and ($pageNum = 0)">
			<xsl:value-of select="$collectionFilename"/><xsl:text>.html</xsl:text>
		</xsl:when>
		<xsl:when test="($numCollections &lt;= 1) and ($pageNum = 0)">index.html</xsl:when>
		<xsl:otherwise><xsl:value-of select="$collectionFilename"/>_<xsl:value-of select="number($pageNum)" />.html</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="currentPageOfTotal">
	<xsl:param name="count"/>
	<xsl:param name="currentPage"/>
	<p class="currentOfTotal">
		<span class="currentPageNumber">
			<xsl:value-of select="$currentPage + 1"/>
		</span>
		<span class="currentTotalSeparator"> / </span>
		<span class="totalPageCount">
			<xsl:value-of select="$count"/>
		</span>
	</p>
</xsl:template>

<!-- ##################### IMAGE PAGE GENERATION ########################## -->
<!--
Displays a single image on the page, with full details about that image.
-->
<xsl:template name="imagePage">
	<xsl:param name="indexPage"/>
	<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<meta name="generator" content="digiKam"/>
		<title><xsl:value-of select="title"/></title>
		<link rel="stylesheet" type="text/css" media="screen">
			<xsl:attribute name="href">../html5responsive/resources/css/<xsl:value-of select="$style"/></xsl:attribute>
		</link>
	</head>
	<body class="imagePage">
		<header>
			<div id="pageTitleAndPagination">
				<h1>
					<xsl:value-of select="title"/>
				</h1>
				<nav class="topOfPage">
					<p class="upLink albumNameLink">
						<a href="{$indexPage}">
							<xsl:value-of select="../name"/>
						</a>					
					</p>	
					<xsl:if test="($paginationLocation = 'top') or ($paginationLocation = 'both')">
						<xsl:call-template name="image.pagination">
							<xsl:with-param name="indexPage" select="$indexPage"/>
						</xsl:call-template>
					</xsl:if>
				</nav>
			</div>
		</header>
	<main>
		<figure id="image">
			<a href="{$indexPage}">
				<img src="{full/@fileName}" width="{full/@width}" height="{full/@height}" />
			</a>
			<xsl:variable name="exifTableRequired">
				<xsl:call-template name="isExifTableRequired"/>
			</xsl:variable>
			<xsl:if test="description != '' or original/@fileName != '' or $exifTableRequired = 'true'">
				<figcaption>
					<xsl:if test="description != ''">
						<p class="imageDescription">
							<xsl:call-template name="convertNewlinesToHtmlBreaks">
								<xsl:with-param name="rawText" select="description"/>
							</xsl:call-template>
						</p>
					</xsl:if>
					<xsl:if test="$exifTableRequired = 'true'">
						<xsl:call-template name="addExifData"/>
					</xsl:if>
					<xsl:if test="original/@fileName != ''">
						<p class="originalImageLink">
							<a href="{original/@fileName}"><xsl:value-of select="$i18nOriginalImage"/></a>
							(<xsl:value-of select="original/@width"/>x<xsl:value-of select="original/@height"/>)
						</p>
					</xsl:if>
				</figcaption>
			</xsl:if>
		</figure>
	</main>
	<xsl:if test="$author != '' or ($paginationLocation = 'bottom') or ($paginationLocation = 'both')">
		<footer>
			<div class="paginationAndCopyright">
				<xsl:if test="($paginationLocation = 'bottom') or ($paginationLocation = 'both')">
					<nav class="bottomOfPage">
						<xsl:call-template name="image.pagination">
							<xsl:with-param name="indexPage" select="$indexPage"/>
						</xsl:call-template>
					</nav>
				</xsl:if>
				<xsl:if test="$author != ''">
					<xsl:call-template name="copyrightNotice"/>
				</xsl:if>
			</div>
		</footer>
	</xsl:if>
</body>
</html>
</xsl:template>

<xsl:template name="isExifTableRequired">
	<xsl:choose>
		<!-- IMPORTANT: IF THE EXIF FIELDS CONSIDERED HERE ARE CHANGED THEN THE EXACT SAME LIST OF FIELDS MUST BE LISTED IN THE "addExifData" TEMPLATE! -->
		<xsl:when test="exif/exifimagedatetime != 'unavailable' or exif/exifimagemake != 'unavailable' or exif/exifimagemodel != 'unavailable' or exif/exifphotofocallength != 'unavailable' or exif/exifphotoaperturevalue != 'unavailable' or exif/exifphotoshutterspeedvalue != 'unavailable' or exif/exifphotoisospeedratings != 'unavailable' or exif/exifphotofnumber != 'unavailable' or exif/exifphotoexposuretime != 'unavailable' or ($showGPS = 'true' and (exif/exifgpslatitude != 'unavailable' or exif/exifgpslongitude != 'unavailable' or exif/exifgpsaltitude != 'unavailable'))">
			<xsl:text>true</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>false</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="addExifData">
	<table class="exifData">
		<caption><abbr title="Exchangeable image file">Exif</abbr> data</caption>
		<tr class="exifHeaderRow">
			<th scope="col">Field</th>
			<th scope="col">Value</th>
		</tr>
		<!-- IMPORTANT: IF THE EXIF FIELDS USED HERE ARE CHANGED THEN THE EXACT SAME LIST OF FIELDS MUST BE CONSIDERED IN THE "isExifTableRequired" TEMPLATE! -->
		<xsl:call-template name="addExifTableRow">
			<xsl:with-param name="cssClassName">exifDateTime</xsl:with-param>
			<xsl:with-param name="fieldName" select="$i18nexifimagedatetime"/>
			<xsl:with-param name="fieldValue" select="exif/exifimagedatetime"/>
		</xsl:call-template>
		<xsl:call-template name="addExifTableRow">
			<xsl:with-param name="cssClassName">hardwareMake</xsl:with-param>
			<xsl:with-param name="fieldName" select="$i18nexifimagemake"/>
			<xsl:with-param name="fieldValue" select="exif/exifimagemake"/>
		</xsl:call-template>
		<xsl:call-template name="addExifTableRow">
			<xsl:with-param name="cssClassName">hardwareModel</xsl:with-param>
			<xsl:with-param name="fieldName" select="$i18nexifimagemodel"/>
			<xsl:with-param name="fieldValue" select="exif/exifimagemodel"/>
		</xsl:call-template>
		<xsl:call-template name="addExifTableRow">
			<xsl:with-param name="cssClassName">focalLength</xsl:with-param>
			<xsl:with-param name="fieldName" select="$i18nexifphotofocallength"/>
			<xsl:with-param name="fieldValue" select="exif/exifphotofocallength"/>
		</xsl:call-template>
		<xsl:call-template name="addExifTableRow">
			<xsl:with-param name="cssClassName">apertureValue</xsl:with-param>
			<xsl:with-param name="fieldName" select="$i18nexifphotoaperturevalue"/>
			<xsl:with-param name="fieldValue" select="exif/exifphotoaperturevalue"/>
		</xsl:call-template>
		<xsl:call-template name="addExifTableRow">
			<xsl:with-param name="cssClassName">shutterSpeedValue</xsl:with-param>
			<xsl:with-param name="fieldName" select="$i18nexifphotoshutterspeedvalue"/>
			<xsl:with-param name="fieldValue" select="exif/exifphotoshutterspeedvalue"/>
		</xsl:call-template>
		<xsl:call-template name="addExifTableRow">
			<xsl:with-param name="cssClassName">fNumber</xsl:with-param>
			<xsl:with-param name="fieldName" select="$i18nexifphotofnumber"/>
			<xsl:with-param name="fieldValue" select="exif/exifphotofnumber"/>
		</xsl:call-template>
		<xsl:call-template name="addExifTableRow">
			<xsl:with-param name="cssClassName">exposureTime</xsl:with-param>
			<xsl:with-param name="fieldName" select="$i18nexifphotoexposuretime"/>
			<xsl:with-param name="fieldValue" select="exif/exifphotoexposuretime"/>
		</xsl:call-template>
		<xsl:call-template name="addExifTableRow">
				<xsl:with-param name="cssClassName">isoSpeed</xsl:with-param>
			<xsl:with-param name="fieldName" select="$i18nexifphotoisospeedratings"/>
			<xsl:with-param name="fieldValue" select="exif/exifphotoisospeedratings"/>
		</xsl:call-template>
		<xsl:if test="$showGPS = 'true'">
			<xsl:call-template name="addExifTableRow">
				<xsl:with-param name="cssClassName">gpsLatitude</xsl:with-param>
				<xsl:with-param name="fieldName">GPS latitude</xsl:with-param>
				<xsl:with-param name="fieldValue" select="exif/exifgpslatitude"/>
			</xsl:call-template>
			<xsl:call-template name="addExifTableRow">
				<xsl:with-param name="cssClassName">gpsLongitude</xsl:with-param>
				<xsl:with-param name="fieldName">GPS longitude</xsl:with-param>
				<xsl:with-param name="fieldValue" select="exif/exifgpslongitude"/>
			</xsl:call-template>
			<xsl:call-template name="addExifTableRow">
				<xsl:with-param name="cssClassName">gpsAltitude</xsl:with-param>
				<xsl:with-param name="fieldName">GPS altitude</xsl:with-param>
				<xsl:with-param name="fieldValue" select="exif/exifgpsaltitude"/>
			</xsl:call-template>
		</xsl:if>
		<!-- IMPORTANT: IF THE EXIF FIELDS USED HERE ARE CHANGED THEN THE EXACT SAME LIST OF FIELDS MUST BE CONSIDERED IN THE "isExifTableRequired" TEMPLATE! -->
	</table>
</xsl:template>

<xsl:template name="addExifTableRow">
	<xsl:param name="cssClassName"/>
	<xsl:param name="fieldName"/>
	<xsl:param name="fieldValue"/>
	<xsl:if test="$fieldValue != '' and $fieldValue != 'unavailable'">
		<tr class="{$cssClassName}">
			<th scope="row"><xsl:value-of select="$fieldName"/></th>
			<td><xsl:value-of select="$fieldValue"/></td>
		</tr>
	</xsl:if>
</xsl:template>

<!-- ##################### END IMAGE PAGE GENERATION ###################### -->


<!-- ##################### IMAGE PAGINATION LINK GENERATATION ############# -->
<xsl:template name="image.pagination">
	<xsl:param name="indexPage"/>
	<div class="pagination">
		<div>
			<xsl:choose>
				<xsl:when test="position() &gt; 1">
					<p class="previousLink">
						<a href="{preceding-sibling::image[position()=1]/full/@fileName}.html">
							<xsl:value-of select="$i18nPrevious"/>
						</a>
					</p>
				</xsl:when>
				<xsl:otherwise>
					<p class="previousLink disabled">
						<xsl:value-of select="$i18nPrevious"/>
					</p>
				</xsl:otherwise>
			</xsl:choose>
			
			<p class="currentOfTotal">
				<span class="currentPageNumber">
					<xsl:value-of select="position()"/>
				</span>
				<span class="currentTotalSeparator">/</span>
				<span class="totalPageCount">
					<xsl:value-of select="last()"/>
				</span>
			</p>
			
			<xsl:choose>
				<xsl:when test="position() &lt; last()">
					<p class="nextLink">
						<a href="{following-sibling::image[position()=1]/full/@fileName}.html"><xsl:value-of select="$i18nNext"/></a>
					</p>
				</xsl:when>
				<xsl:otherwise>
					<p class="nextLink disabled">
						<xsl:value-of select="$i18nNext"/>
					</p>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</div>
</xsl:template>
<!-- ##################### END PAGINATION LINK GENERATATION ############### -->


<!-- ##################### COLLECTION PAGES GENERATION ##################### -->
<xsl:template name="collectionPages">
	<xsl:call-template name="collectionPages.for.loop">
		<xsl:with-param name="i" select="1"/>
		<xsl:with-param name="count" select="ceiling(count(image) div $pageSize)"/>
	</xsl:call-template>
</xsl:template>

<!-- For loop used to generate collection pages -->
<xsl:template name="collectionPages.for.loop">
	<xsl:param name="i"/>
	<xsl:param name="count"/>
	
	<xsl:if test="$i &lt; $count">
		<xsl:variable name="pageFilename" select="concat(fileName, '_', $i, '.html')"/>
		<exsl:document href="{$pageFilename}"
				method="html"
				indent="yes" 
				encoding="utf-8" 
				doctype-system="about:legacy-compat">
			<xsl:call-template name="collectionPage">
				<xsl:with-param name="pageNum" select="$i"/>
				<xsl:with-param name="pageFilename" select="$pageFilename"/>
			</xsl:call-template>
		</exsl:document>
		
		<xsl:call-template name="collectionPages.for.loop">
			<xsl:with-param name="i" select="$i + 1"/>
			<xsl:with-param name="count" select="$count"/>
		</xsl:call-template>
	</xsl:if>
</xsl:template>
<!-- ##################### END COLLECTION PAGE GENERATION ################# -->

</xsl:transform>