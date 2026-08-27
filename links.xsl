<?xml version="1.0"?>
<!-- SPDX-License-Identifier: CC0-1.0 -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="http://www.forester-notes.org" xmlns:html="http://www.w3.org/1999/xhtml">

  <xsl:template match="text()[ancestor::f:link[1]/@href]">
    <a href="{ancestor::f:link[1]/@href}">
      <xsl:choose>
        <xsl:when test="ancestor::f:link[1]/@display-uri">
          <xsl:attribute name="title">
            <xsl:value-of select="ancestor::f:link[1]/@title" />
            <xsl:text> [</xsl:text>
            <xsl:value-of select="ancestor::f:link[1]/@display-uri" />
            <xsl:text>]</xsl:text>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="title">
            <xsl:value-of select="ancestor::f:link[1]/@title" />
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="."/>
    </a>
  </xsl:template>

  <xsl:template match="f:link">
    <span class="link {@type}">
      <xsl:apply-templates  />
    </span>
  </xsl:template>

  <!-- Mode `row-title`: a title rendered somewhere that is itself one link.
       The index-entry rule in tree.xsl wraps a listing row's title in an <a>
       to its own page, and titles here routinely carry links of their own —
       the convention is to link the concept a tree is about in its \title, so
       a deck listing on AGCA is full of them. An <a> inside an <a> is not
       valid HTML, and the parser does not nest them: it closes the outer
       anchor at the inner one, which leaves the row as a fragment of link, a
       link to somewhere else, then plain text.

       So inside a row title a link renders as its own text and nothing else.
       That is the right reading regardless of the markup: a listing row is one
       navigation target, and a title that quietly sends part of itself
       somewhere else is a trap. The slug beside it still goes to the entry,
       and the inner link is one hop away on the entry's own page.

       The html:* rule mirrors core.xsl's, but recurses in this mode so that a
       link inside emphasis in a title is flattened too; anything else — math,
       most of all — falls through to its ordinary template, since none of it
       can contain a link. -->
  <xsl:template match="f:link" mode="row-title">
    <xsl:apply-templates mode="row-title" />
  </xsl:template>

  <xsl:template match="text()" mode="row-title">
    <xsl:value-of select="." />
  </xsl:template>

  <xsl:template match="html:*" mode="row-title">
    <xsl:element namespace="http://www.w3.org/1999/xhtml" name="{local-name()}">
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates select="node()" mode="row-title" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="*" mode="row-title">
    <xsl:apply-templates select="." />
  </xsl:template>

</xsl:stylesheet>
