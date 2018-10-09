<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes"/>


    <xsl:param name="articleFlavour" select="'P'" />
    <xsl:param name="articleType" select="'ShortStory'" />

    <!-- Identita -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="//ParagraphStyleRange[@AppliedParagraphStyle='ParagraphStyle/Paragraph']">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:variable name="precedingStyle" select="preceding-sibling::ParagraphStyleRange[1]/@AppliedParagraphStyle" />

            <xsl:if test="$precedingStyle = 'ParagraphStyle/Header2'">
                <xsl:attribute name="AppliedParagraphStyle">ParagraphStyle/FirstParagraph</xsl:attribute>
            </xsl:if>

            <xsl:if test="$precedingStyle = 'ParagraphStyle/Header3'">
                <xsl:attribute name="AppliedParagraphStyle">ParagraphStyle/FirstParagraph</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="RootParagraphStyleGroup[@Self='pandoc_paragraph_styles']">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>

            <xsl:element name="ParagraphStyle">
                <xsl:attribute name="Self">ParagraphStyle/Perex<xsl:value-of select="$articleFlavour"/></xsl:attribute>
                <xsl:attribute name="Name">Záhlaví <xsl:value-of select="$articleFlavour"/> perex</xsl:attribute>
            </xsl:element>

            <xsl:element name="ParagraphStyle">
                <xsl:attribute name="Self">ParagraphStyle/ArticleFrontMatter<xsl:value-of select="$articleFlavour"/></xsl:attribute>
                <xsl:attribute name="Name">Záhlaví <xsl:value-of select="$articleFlavour"/> autor/rubrika</xsl:attribute>
            </xsl:element>

            <xsl:element name="ParagraphStyle">
                <xsl:attribute name="Self">ParagraphStyle/Title<xsl:value-of select="$articleFlavour"/></xsl:attribute>
                <xsl:attribute name="Name">Záhlaví <xsl:value-of select="$articleFlavour"/> titul</xsl:attribute>
            </xsl:element>

            <xsl:element name="ParagraphStyle">
                <xsl:attribute name="Self">ParagraphStyle/FirstParagraph</xsl:attribute>
                <xsl:attribute name="Name">První odstavec textu</xsl:attribute>
            </xsl:element>

            <xsl:element name="ParagraphStyle">
                <xsl:attribute name="Self">ParagraphStyle/ShortStoryParagraph</xsl:attribute>
                <xsl:attribute name="Name">Povídka - text</xsl:attribute>
            </xsl:element>
        </xsl:copy>
    </xsl:template>


    <!-- Markdown kurzíva -->
    <xsl:template match="//CharacterStyle[@Self='CharacterStyle/Italic']/@Name">
        <xsl:attribute name="Name">Kurzíva</xsl:attribute>
    </xsl:template>

    <!-- Markdown hyperlink -->
    <xsl:template match="//CharacterStyle[@Self='CharacterStyle/Link']/@Name">
        <xsl:attribute name="Name">Odkaz</xsl:attribute>
    </xsl:template>

    <!-- Markdown ## mapujeme na Nadpis v článku -->
    <xsl:template match="//ParagraphStyle[@Self='ParagraphStyle/Header2']/@Name">
        <xsl:attribute name="Name">Nadpis <xsl:value-of select="$articleFlavour"/></xsl:attribute>
    </xsl:template>

    <!-- Markdown ### mapujeme na Podnadpis -->
    <xsl:template match="//ParagraphStyle[@Self='ParagraphStyle/Header3']/@Name">
        <xsl:attribute name="Name">Podnadpis <xsl:value-of select="$articleFlavour"/></xsl:attribute>
    </xsl:template>

    <!-- Markdown Odsek mapujeme na Odsek -->
    <xsl:template match="//ParagraphStyle[@Self='ParagraphStyle/Paragraph']/@Name">
        <xsl:choose>
            <xsl:when test="$articleType = 'ShortStory'">
                <xsl:attribute name="Name">Povídka - text</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="Name">Text článku</xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Číslovania -->
    <xsl:template match="//ParagraphStyle[@Self='ParagraphStyle/NumList &gt; Paragraph']">
        <xsl:element name="ParagraphStyle">
            <xsl:attribute name="Self">ParagraphStyle/NumList &gt; Paragraph</xsl:attribute>
            <xsl:attribute name="Name">Seznam číslovaný</xsl:attribute>
            <xsl:element name="Properties">
                <xsl:element name="BasedOn">
                    <xsl:attribute name="type">object</xsl:attribute>
                    $ID/NormalParagraphStyle
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="//ParagraphStyle[@Self='ParagraphStyle/NumList &gt; first &gt; Paragraph']">
        <xsl:element name="ParagraphStyle">
            <xsl:attribute name="Self">ParagraphStyle/NumList &gt; first &gt; Paragraph</xsl:attribute>
            <xsl:attribute name="Name">Seznam číslovaný</xsl:attribute>
            <xsl:element name="Properties">
                <xsl:element name="BasedOn">
                    <xsl:attribute name="type">object</xsl:attribute>
                    $ID/NormalParagraphStyle
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <!-- Markdown * mapujeme na seznam s puntíky -->
    <xsl:template match="//ParagraphStyle[@Self='ParagraphStyle/BulList &gt; Paragraph']/@Name">
        <xsl:attribute name="Name">Seznam s puntíky</xsl:attribute>
    </xsl:template>

    <!-- Markdown * mapujeme na seznam s puntíky -->
    <xsl:template match="//ParagraphStyle[@Self='ParagraphStyle/BulList']/@Name">
        <xsl:attribute name="Name">Seznam s puntíky</xsl:attribute>
    </xsl:template>

    <!-- Markdown * a prvý odsek je špeciálny. Namapujeme to na špeciálny štýl -->
    <xsl:template match="//ParagraphStyle[@Self='ParagraphStyle/BulList &gt; first &gt; Paragraph']/@Name">
        <xsl:attribute name="Name">Seznam s puntíky - první odstavec</xsl:attribute>
    </xsl:template>

    <!-- Markdown * a prvý odsek je špeciálny. Namapujeme to na špeciálny štýl -->
    <xsl:template match="//ParagraphStyle[@Self='ParagraphStyle/BulList &gt; first']/@Name">
        <xsl:attribute name="Name">Seznam s puntíky - první odstavec</xsl:attribute>
    </xsl:template>

    <!-- Citácie -->
    <xsl:template match="//ParagraphStyle[@Self='ParagraphStyle/Blockquote &gt; Paragraph']/@Name">
        <xsl:attribute name="Name">Citace <xsl:value-of select="$articleFlavour"/></xsl:attribute>
    </xsl:template>

    <xsl:template match="//CharacterStyle[@Self='CharacterStyle/Italic Link']/@Name">
        <xsl:attribute name="Name">Odkaz kurzívou</xsl:attribute>
    </xsl:template>

    <xsl:template match="//CharacterStyle[@Self='CharacterStyle/Code']/@Name">
        <xsl:attribute name="Name">Produkt</xsl:attribute>
    </xsl:template>

    <xsl:template match="//CharacterStyle[@Self='CharacterStyle/Code Link']/@Name">
        <xsl:attribute name="Name">Produkt kurzívou</xsl:attribute>
    </xsl:template>

    <xsl:template match="//CharacterStyle[@Self='CharacterStyle/SmallCaps']/@Name">
        <xsl:attribute name="Name">Citace v textu <xsl:value-of select="$articleFlavour"/></xsl:attribute>
    </xsl:template>

</xsl:stylesheet>