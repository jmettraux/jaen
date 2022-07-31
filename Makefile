
#NAME_ != git branch --show-current | sed -e "s/[^-_a-zA-Z0-9]/_/g"
NAME_ != grep "NAME_:" Config.yaml | cut -d ": " -f 2 | sed 's/^ *//'

RUBY = ruby
RUM = $(RUBY) -Ilib -r make -e


all: ps

html0: clean
	touch out/tmp/.gitkeep
	touch out/html/.gitkeep
	cp lib/assets/blank*.pdf out/tmp/
	cp lib/assets/*.ico out/html/
	cp lib/assets/*.png out/html/
	cp lib/assets/*.css out/html/
	cp lib/assets/*.svg out/html/
	cp src/_creatures.js out/html/
	cp src/*.svg out/html/
	$(RUM) make_creatures
html: html0
	$(RUM) make_html
h: html

pdf: html
	$(RUM) make_pdf
	pdfinfo out/html/$(NAME_).pdf
ps: pdf
	$(RUM) make_ps
	pdfinfo out/html/$(NAME_).a5.pdf

tod: ps
	cp out/html/character_sheet.pdf ~/Downloads/
	cp out/html/character_sheet_0.pdf ~/Downloads/
	cp out/html/$(NAME_).pdf ~/Downloads/
	cp out/html/$(NAME_).a5.pdf ~/Downloads/
	cp out/html/$(NAME_).stapled.pdf ~/Downloads/
	cp out/html/$(NAME_).stapled.2.duplex.ps.zip ~/Downloads/

blank:
	echo "" | ps2pdf -sPAPERSIZE=a4 - out/tmp/blank_a4.pdf
	echo "" | ps2pdf -sPAPERSIZE=letter - out/tmp/blank_letter.pdf

pkg: html
	rm -fR $(NAME_)_html
	mkdir $(NAME_)_html
	cp out/html/$(NAME_).html $(NAME_)_html/
	cp out/html/$(NAME_).css $(NAME_)_html/
	cp out/html/normalize-8.0.1.css $(NAME_)_html/
	zip $(NAME_)_html.zip $(NAME_)_html/*

name:
	@echo $(NAME_)

serve:
	$(RUBY) -run -ehttpd out/html/ -p7004
s: serve

clean:
	rm -f out/tmp/*.md
	rm -f out/tmp/*.pdf
	rm -f out/tmp/*.html
	rm -f out/html/*.ps
	rm -f out/html/*.ps.zip
	rm -f out/html/*.pdf
	rm -f out/html/*.css
	rm -f out/html/*.ico
	rm -f out/html/*.png
	rm -f out/html/*.svg
	rm -f out/html/*.html
	rm -fR out/html/* #out/html/.*


.PHONY: name serve clean

