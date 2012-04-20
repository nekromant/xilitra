Kbuild:=Kconfig
obj:=kconfig
src:=kconfig
Kconfig:=./kcnf
KVersion:=./version.kcnf
KCONFIG_CONFIG?=.config
PHONY+=collectinfo
-include .config
-include .version

SRCDIR=.
TMPDIR=tmp
WORKDIR=work
STAMPDIR=stamps

export SRCDIR TMPDIR WORKDIR STAMPDIR

include $(SRCDIR)/kconfig/kconfig.mk

PHONY+=clean kconfig_clean mrproper
CONFIG_MAKE_DEFTARGET := $(subst ",, $(CONFIG_MAKE_DEFTARGET))

all: $(CONFIG_MAKE_DEFTARGET)
	@echo "Default target $(CONFIG_MAKE_DEFTARGET) remade"

	
clean: kconfig_clean 
	rm -rf $(TMPDIR)/*
	rm -rf $(WORKDIR)/*

mrproper: clean
	find . -iname "*~"| while read line; do rm $$line; done
	@echo "Хлебнул Ксилитры ::: Ээээх, пропёрло-то как"

newpkg: 
	KCONFIG_CONFIG=tmp/pkg $(MAKE) Kconfig=./pkg.kcnf menuconfig
	
cdeps=$(shell for file in `ls $(SRCDIR)/scripts/collectors/|grep -v "~"`; do\
		SRCDIR=$(SRCDIR) TMPDIR=$(TMPDIR) $(SRCDIR)/scripts/collectors/$$file deps;\
	done)
	
collectinfo: $(TMPDIR)/.collected

$(TMPDIR)/.collected: $(cdeps)
	mkdir -p $(TMPDIR)
	mkdir -p $(WORKDIR)
	mkdir -p $(STAMPDIR)
	for file in `ls $(SRCDIR)/scripts/collectors/|grep -v "~"`; do\
		$(SRCDIR)/scripts/collectors/$$file;\
	done
	touch $@
	
.PHONY: $(PHONY)
