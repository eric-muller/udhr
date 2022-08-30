S=staging
A=$S/assemblies

ICU_JAR=../external/icu4j-65_1.jar
JING_JAR=../external/jing.jar
SAXON_JAR=../external/saxon9he.jar
TRANG_JAR=../external/trang.jar

XSLT=java -cp $(SAXON_JAR) net.sf.saxon.Transform --suppressXsltNamespaceCheck:on



all: clean check_index webpages status xml txt html archives


lang: status validate txt html

tidy:
	rm -f *~
	(cd ../data/udhr; rm -f *~)
	(cd xsl; rm -f *~)

clean: tidy
	rm -fr staging
	rm -fr .ignore

webpages::
	@echo ---- webpages
	@mkdir -p $S $S/n $S/d $S/s $A $S/assemblies
	@cp -R ../external/cdn $S

	@for f in index \
	          aggregates downloads news \
	          contributing contributors contacts \
	          tech_whichtext tech_whichcharacter tech_langid tech_files; do \
	  $(XSLT) -s:$$f.xml -xsl:xsl/pages.xsl -o:$S/$$f.html; \
	done

	@$(XSLT) -s:../data/udhr/index.xml -xsl:xsl/indexpage.xsl | \
	 $(XSLT) -s:- -xsl:xsl/pages.xsl -o:$S/translations.html

	@$(XSLT) -s:../data/udhr/index.xml -xsl:xsl/index2map.xsl -o:$S/markers.js
	@cp map.js $S

	@cp ../data/udhr/schema.rnc $S/d
	@cp ../data/udhr/schema.rng $S/d


status:
	@echo ---- status
	@$(XSLT) -s:../data/udhr/index.xml -xsl:xsl/udhrs2status-multiple.xsl \
		targetdir=$S/s/ root-dir=../ \
		-o:.ignore
	cp ../data/status/status_kdh_* $S/s

xml:
	@echo ---- xml
	@for f in ../data/udhr/index.xml ../data/udhr/udhr_$(ONLY)*.xml; do \
	  cp $$f $S/d/`basename $$f`; \
	done

../data/udhr/schema.rng: ../data/udhr/schema.rnc
	java -jar "${TRANG_JAR}" ../data/udhr/schema.rnc ../data/udhr/schema.rng

validate: ../data/udhr/schema.rng
	@echo ---- validate
	@for f in ../data/udhr/udhr_$(ONLY)*.xml; do \
	  echo ====== $$f; \
	  java -Xmx384M -jar "${JING_JAR}" ../data/udhr/schema.rng $$f; \
	done

check_index:
	@echo ---- index check
	@$(XSLT) -s:../data/udhr/index.xml -xsl:xsl/check_index.xsl

txt:
	@echo ---- txt, first article, subset
	@$(XSLT) -s:../data/udhr/index.xml -xsl:xsl/udhrs2txt.xsl \
		split-into='#no' full=no subset=yes \
		-o:$A/first_article_subset.txt

	@echo ---- txt, first article, all
	@$(XSLT) -s:../data/udhr/index.xml -xsl:xsl/udhrs2txt.xsl \
		split-into='#no' full=no subset=no \
		-o:$A/first_article_all.txt

	@echo ---- txt, full, subset
	@$(XSLT) -s:../data/udhr/index.xml -xsl:xsl/udhrs2txt.xsl \
		split-into='#no' full=yes subset=yes \
		-o:$A/full_subset.txt

	@echo ---- txt, full, all
	@$(XSLT) -s:../data/udhr/index.xml -xsl:xsl/udhrs2txt.xsl \
		split-into='#no' full=yes subset=no \
		-o:$A/full_all.txt

	@echo ---- txt, individual versions
	@$(XSLT) -s:../data/udhr/index.xml -xsl:xsl/udhrs2txt.xsl \
		split-into=$S/d/ \
		-o:.ignore

html:
	@echo ---- html, first article, subset
	@$(XSLT) -s:../data/udhr/index.xml -xsl:xsl/udhrs2html.xsl \
		split-into='#no' full=no subset=yes \
		-o:$A/first_article_subset.html

	@echo ---- html, first article, all
	@$(XSLT) -s:../data/udhr/index.xml -xsl:xsl/udhrs2html.xsl \
		split-into='#no' full=no subset=no \
		-o:$A/first_article_all.html

	@echo ---- html, full, subset
	@$(XSLT) -s:../data/udhr/index.xml -xsl:xsl/udhrs2html.xsl \
		split-into='#no' full=yes subset=yes \
		-o:$A/full_subset.html

	@echo ---- html, full, all
	@$(XSLT) -s:../data/udhr/index.xml -xsl:xsl/udhrs2html.xsl \
		split-into='#no' full=yes subset=no \
		-o:$A/full_all.html


	@echo ---- html, individual versions
	@$(XSLT) -s:../data/udhr/index.xml -xsl:xsl/udhrs2html.xsl \
		split-into=$S/d/ full=yes subset=no \
		-o:.ignore

archives:
	@echo ---- archive, xml
	@(cd $S/d; jar cfM ../assemblies/udhr_xml.zip udhr_*.xml index.xml schema.rnc schema.rng)

	@for t in txt html; do \
	  echo ---- archive, $$t; \
	  (cd $S/d; jar cfM ../assemblies/udhr_$$t.zip udhr_*.$$t index.xml); \
	done

	@cp xsl/udhrs2html.xsl xsl/udhrs2txt.xsl $A
