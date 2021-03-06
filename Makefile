DRAFT=draft-iab-html-rfc
BRANCH := $(shell git symbolic-ref --short HEAD)

.PHONY: clean example publish start stop

%.txt: %.xml
	xml2rfc --text --html $<

%.html: %.xml
	xml2rfc --text --html $<

all: $(DRAFT).txt example

clean:
	$(RM) $(DRAFT).html $(DRAFT).3.html $(DRAFT).3.xml $(DRAFT).n.xml $(DRAFT).txt
	@$(MAKE) -C example clean

example:
	@$(MAKE) -C example

start:
	@$(MAKE) -C example start

stop:
	@$(MAKE) -C example stop

publish: $(DRAFT).txt
	git co gh-pages
	git co $(BRANCH) -- example/xml2rfc.css
	git co $(BRANCH) -- example/test.x.xml
	git co $(BRANCH) -- example/test.n.xml
	git co $(BRANCH) -- example/test.3.xml
	git co $(BRANCH) -- example/test.3.html
	git co $(BRANCH) -- $(DRAFT).txt
	git co $(BRANCH) -- $(DRAFT).xml
	git co $(BRANCH) -- $(DRAFT).html
	git ci -m "Publish to GitHub pages"
	git push origin gh-pages
	git co $(BRANCH)
