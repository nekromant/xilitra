Kbuild:=Kconfig
obj:=kconfig
src:=kconfig
Kconfig:=./kcnf
KVersion:=./version.kcnf
KCONFIG_CONFIG?=.config
PHONY+=collectinfo
-include .config
-include .version
-include Makefile.common

SRCDIR=.
TEMPDIR=tmp
WORKDIR=work
STAMPDIR=stamps
DLDIR=$(call unquote,$(CONFIG_DLDIR))

export SRCDIR TEMPDIR WORKDIR STAMPDIR DLDIR

include $(SRCDIR)/kconfig/kconfig.mk

PHONY+=clean kconfig_clean mrproper collectinfo
CONFIG_MAKE_DEFTARGET := $(subst ",, $(CONFIG_MAKE_DEFTARGET))

all: $(CONFIG_MAKE_DEFTARGET)
	@echo "Default target $(CONFIG_MAKE_DEFTARGET) remade"

	
clean: kconfig_clean 
	rm -rf $(TEMPDIR)/*
	rm -rf $(TEMPDIR)/.*
	rm -rf $(WORKDIR)/*

mrproper: clean
	find . -iname "*~"| while read line; do rm $$line; done
	@echo "Хлебнул Ксилитры ::: Ээээх, пропёрло-то как"

newpkg: 
	KCONFIG_CONFIG=tmp/pkg $(MAKE) Kconfig=./pkg.kcnf menuconfig
	
cdeps=$(shell for file in `ls $(SRCDIR)/scripts/collectors/|grep -v "~"`; do\
		SRCDIR=$(SRCDIR) TEMPDIR=$(TEMPDIR) $(SRCDIR)/scripts/collectors/$$file deps;\
	done)
	
collectinfo: $(TEMPDIR)/.collected

$(TEMPDIR)/.collected: $(cdeps)
	mkdir -p $(TEMPDIR)
	mkdir -p $(WORKDIR)
	mkdir -p $(STAMPDIR)
	mkdir -p $(DLDIR)
	for file in `ls $(SRCDIR)/scripts/collectors/|grep -v "~"`; do\
		$(SRCDIR)/scripts/collectors/$$file;\
	done
	touch $@


-include $(TEMPDIR)/targets.mk

build: $(TEMPDIR)/.collected
	$(info $(platforms-y))
	$(foreach target, $(platforms-y),\
	mkdir -p $(WORKDIR)/$(target);\
	$(MAKE) DLDIR=$(DLDIR) TARGET=$(target) WORKDIR=$(WORKDIR)/$(target) -f $(SRCDIR)/Makefile.build; )

build-%: $(TEMPDIR)/.collected
	
	
.PHONY: $(PHONY)
