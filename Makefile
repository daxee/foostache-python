CLASSPATH_DIR=classpath
ANTLR4_JAR=$(CLASSPATH_DIR)/antlr-4.5.1-complete.jar

XYZ=http://www.antlr.org/download/antlr-javascript-runtime-4.5.1.zip

ROOT_DIR=$(shell pwd)
SOURCE_DIR=language/antlr4

TARGET_DIR=foostache/parser

generated = $(TARGET_DIR)/FoostacheLexer.py \
	$(TARGET_DIR)/FoostacheLexer.tokens \
	$(TARGET_DIR)/FoostacheParser.py \
	$(TARGET_DIR)/FoostacheParser.tokens \
	$(TARGET_DIR)/FoostacheParserListener.py \
	$(TARGET_DIR)/FoostacheParserVisitor.py


$(generated) : $(ANTLR4_JAR) $(SOURCE_DIR)/FoostacheLexer.g4 $(SOURCE_DIR)/FoostacheParser.g4
	mkdir -p $(TARGET_DIR)
	cd $(SOURCE_DIR); java -Xmx500M -cp $(ROOT_DIR)/$(ANTLR4_JAR) org.antlr.v4.Tool -Dlanguage=JavaScript -visitor -o $(ROOT_DIR)/$(TARGET_DIR) FoostacheLexer.g4 FoostacheParser.g4

$(ANTLR4_JAR) :
	mkdir -p $(CLASSPATH_DIR)
	curl -L http://www.antlr.org/download/antlr-4.5.1-complete.jar -o $(ANTLR4_JAR)

.PHONY : clean distclean dist pypi pypitest

distclean : clean
	rm -f $(generated)
	find foostache -name *.pyc -delete

clean :
	rm -rf build dist foostache.egg-info

dist : clean $(generated)
	python ./setup.py sdist bdist_wheel

pypi : dist
	twine upload -r pypi dist/*

pypitest : dist
	twine upload -r test dist/*
