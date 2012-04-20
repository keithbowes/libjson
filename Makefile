AR ?= ar
CC ?= gcc
CFLAGS ?= -Wall -Os -fPIC
LDFLAGS = -L.
SHLIB_CFLAGS = -shared

INSTALL_EXEC = install -m 755 -o root -g root
INSTALL_DATA = install -m 644 -o root -g root
COPY_PRESERVELINKS = cp -d
INSTALL_SOLINKS = $(COPY_PRESERVELINKS)

MAJOR = 1
MINOR = 0
MICRO = 0

NAME = json
A_TARGETS = $(LIBPREF)$(NAME).a
BIN_TARGETS = $(NAME)lint$(EXEEXT)
PC_TARGET = lib$(NAME).pc
SO_LINKS = $(LIBPREF)$(NAME)$(SOEXT) $(LIBPREF)$(NAME)$(SOEXT).$(MAJOR) $(LIBPREF)$(NAME)$(SOEXT).$(MAJOR).$(MINOR)
SO_FILE = $(LIBPREF)$(NAME)$(SOEXT).$(MAJOR).$(MINOR).$(MICRO)
HEADERS = $(NAME).h

PREFIX ?= /usr
DESTDIR ?=
INSTALLDIR ?= $(DESTDIR)$(PREFIX)

TARGETS = $(A_TARGETS) $(SO_FILE) $(SO_LINKS) $(BIN_TARGETS) $(PC_TARGET)

ifeq ($(findstring mingw32,$(CC)),)
EXEEXT=
LIBPREF=lib
LN = ln
LNFLAGS = -sf
SOEXT = .so
else
EXEEXT=.exe
LIBPREF=
LN = mv
LNFLAGS= -f
SOEXT = .dll
endif

all: $(TARGETS)

$(LIBPREF)$(NAME).a: $(NAME).o
	$(AR) rc $@ $+

$(LIBPREF)$(NAME)$(SOEXT): $(LIBPREF)$(NAME)$(SOEXT).$(MAJOR)
	$(LN) $(LNFLAGS) $< $@

$(LIBPREF)$(NAME)$(SOEXT).$(MAJOR): $(LIBPREF)$(NAME)$(SOEXT).$(MAJOR).$(MINOR)
	$(LN) $(LNFLAGS) $< $@

$(LIBPREF)$(NAME)$(SOEXT).$(MAJOR).$(MINOR): $(LIBPREF)$(NAME)$(SOEXT).$(MAJOR).$(MINOR).$(MICRO)
	$(LN) $(LNFLAGS) $< $@

$(LIBPREF)$(NAME)$(SOEXT).$(MAJOR).$(MINOR).$(MICRO): $(NAME).o
	$(CC) $(CFLAGS) $(LDFLAGS) -shared -o $@ $^

$(NAME)lint$(EXEEXT): $(NAME)lint.o $(NAME).o
	$(CC) $(CFLAGS) -o $@ $+

%.o: %.c %.h
	$(CC) $(CFLAGS) -c -o $@ $<

.PHONY: lib$(NAME).pc
lib$(NAME).pc: lib$(NAME).pc.in
	sed -e 's;@PREFIX@;$(PREFIX);' -e 's;@LIBJSON_VER_MAJOR@;$(MAJOR);' -e 's;@LIBJSON_VER_MINOR@;$(MINOR);' < $< > $@

.PHONY: tests clean install install-bin install-lib
tests: $(NAME)lint$(EXEXT)
	(cd tests; ./runtest)

install-lib: $(SO_TARGETS) $(A_TARGETS) $(PC_TARGET)
	mkdir -p $(INSTALLDIR)/lib/pkgconfig
	$(INSTALL_DATA) -t $(INSTALLDIR)/lib/pkgconfig $(PC_TARGET)
	mkdir -p $(INSTALLDIR)/include
	$(INSTALL_DATA) -t $(INSTALLDIR)/include $(HEADERS)
	mkdir -p $(INSTALLDIR)/lib
	$(INSTALL_EXEC) -t $(INSTALLDIR)/lib $(SO_FILE)
	$(INSTALL_DATA) -t $(INSTALLDIR)/lib $(A_TARGETS)
	$(INSTALL_SOLINKS) $(SO_LINKS) $(INSTALLDIR)/lib

install-bin: $(BIN_TARGETS)
	mkdir -p $(INSTALLDIR)/bin
	$(INSTALL_EXEC) -t $(INSTALLDIR)/bin $(BIN_TARGETS)

install: install-lib install-bin

clean:
	rm -f *.o $(TARGETS)
