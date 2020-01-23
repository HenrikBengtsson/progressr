all: slow_sum.svg

%.svg: %.bob
	svgbob --font-family=monospace --output $@ < $<

%.png: %.svg
	inkscape -z -d 192 -e $@ $<
