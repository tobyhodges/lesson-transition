DIRS := swcarpentry \
	datacarpentry \
	librarycarpentry \
	carpentries-incubator \
	carpentries-lab \
	carpentries
INPUTS  := $(foreach dir, $(DIRS), $(wildcard $(dir)/*R))
TARGETS := $(patsubst %.R, %.txt, $(INPUTS))

.PHONY = all

all: repos.md

repos.md : $(TARGETS)
	rm -f repos.md
	for i in $^;\
	 do repo=$$(echo $$i | sed -e 's/.txt//');\
	 slug=$$(basename $$(echo $${repo} | sed -r -e "s_datacarpentry/([^R])_new-\1_"));\
	 account=$$(dirname $${repo});\
	 echo "- [$${repo}](https://github.com/$${repo}) -> [data-lessons/$${slug}](https://github.com/data-lessons/$${slug})" >> $@;\
	 done

%.txt : %.R transform-lesson.R
	Rscript transform-lesson.R \
	  --build \
	  --save   ../$(@D)/ \
	  --output ../$(@D)/sandpaper/ \
	    $* \
	    $<

datacarpentry/%.txt : datacarpentry/%.R transform-lesson.R
	Rscript transform-lesson.R \
	  --build \
	  --save   ../$(@D)/ \
	  --output ../$(@D)/sandpaper/new- \
	    $* \
	    $<

datacarpentry/R-ecology-lesson.txt : datacarpentry/R-ecology-lesson.R
	Rscript $< \
	  --build \
	  --save ../$(@D)/ \
	  --output ../$(@D)/sandpaper/ \
	    datacarpentry/R-ecology-lesson


