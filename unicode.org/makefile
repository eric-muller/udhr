S=staging
A=$S/assemblies

JARS=../external/saxon9h3.jar:../external/jing.jar:../external/icu4j-4_8_1_1.jar:./java

JAVA="java" -Xmx384M -cp "$(JARS)"

XSLT=java -cp ../external/saxon9he.jar net.sf.saxon.Transform --suppressXsltNamespaceCheck:on



all: clean check_index webpages status notes xml charcount txt html archives


lang: status validate charcount txt html

tidy:
	rm -f *~
	(cd ../data/udhr; rm -f *~)
	(cd ../data/notes; rm -f *~)
	(cd xsl; rm -f *~)

clean: tidy
	rm -fr staging
	rm -fr java/org/unicode/publication/*.class
	rm -fr .ignore

java/org/unicode/publication/CharCounter.class: java/org/unicode/publication/CharCounter.java
	@echo ---- compile CharCounter
	@javac -cp "${JARS}" java/org/unicode/publication/CharCounter.java

webpages::
	@echo ---- webpages
	@mkdir -p $S $S/n $S/d $S/s $A $S/aggregates
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


NOTES= abk afr ame amr bel tem zul hin \
	ron_1993 ron_1953 deu_1901 deu_1996 \
	fra uzn_latn

notes:
	rm -fr $S/n/abk
	@for l in $(NOTES); do \
	  echo ---- notes, $$l; \
	  $(XSLT) -s:../data/notes/notes_$$l.xml -xsl:xsl/pages.xsl \
	    root-dir='./' -o:$S/n/notes_$$l.html; \
	done
	mkdir $S/n/abk
	cp ../data/notes/abk/* $S/n/abk

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

d/schema.rng: ../data/udhr/schema.rnc
	$(JAVA) -jar "${TRANG_JAR}" d/schema.rnc d/schema.rng

validate: d/schema.rng
	@echo ---- validate
	@for f in d/udhr_$(ONLY)*.xml; do \
	  echo ====== $$f; \
	  $(JAVA) -Xmx384M -jar "${JING_JAR}" d/schema.rng $$f; \
	done

check_index:
	@echo ---- index check
	@$(XSLT) -s:../data/udhr/index.xml -xsl:xsl/check_index.xsl

charcount: java/org/unicode/publication/CharCounter.class
	@echo ---- charcount
	@for f in ../data/udhr/udhr_$(ONLY)*.xml; do\
	  $(JAVA) org.unicode.publication.CharCounter $$f \
		> $S/d/`basename $$f .xml`.charcount; \
	done


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

	@for t in charcount txt html; do \
	  echo ---- archive, $$t; \
	  (cd $S/d; jar cfM ../assemblies/udhr_$$t.zip udhr_*.$$t index.xml); \
	done

	@cp xsl/udhrs2html.xsl xsl/udhrs2txt.xsl $A
