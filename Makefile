# Luabash Makefile
.PHONY: clean build install

CC ?= gcc
LIBTOOL ?= libtool
SDIR ?= src
ODIR ?= build
DDIR ?= doc
LINKFLAGS ?= $(shell if [[ $$OSTYPE =~ darwin ]]; then echo '-bundle'; else echo '-shared'; fi; pkg-config --libs lua5.2 2>/dev/null || pkg-config --libs lua; echo "-bundle_loader $$(which bash)")
CFLAGS ?= $(shell pkg-config --cflags lua5.2 2>/dev/null || pkg-config --cflags lua) -Wall -fPIC
PREFIX ?= /usr/share
DLLEXT ?= so

# Get targets and objects
SOURCES := $(wildcard $(SDIR)/*.c)
REL_DLL := luabash.$(DLLEXT)
ABS_DLL := $(ODIR)/$(REL_DLL)

build: $(ABS_DLL)

$(ABS_DLL): $(SOURCES) Makefile
	mkdir -p $(ODIR)
	$(CC) -o $(ABS_DLL) $(SOURCES) $(CFLAGS) $(LINKFLAGS)

clean: 
	rm -rf $(ODIR)

install: 
	install -Dm 644 $(ABS_DLL) $(DESTDIR)$(PREFIX)/luabash/$(REL_DLL)
	install -Dm 644 README.md $(DESTDIR)$(PREFIX)/doc/luabash/README.md
	install -Dm 644 $(DDIR)/example.sh  $(DESTDIR)$(PREFIX)/doc/luabash/doc/example.sh
	install -Dm 644 $(DDIR)/internal.lua  $(DESTDIR)$(PREFIX)/doc/luabash/doc/internal.lua
