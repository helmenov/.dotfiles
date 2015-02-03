SHELL			=	/bin/sh
MKDIR			=	mkdir -p
INSTALL			=	/usr/bin/install -c
EMACS			=	emacs

PACKAGE			=	text-translator

prefix			=	/usr/local
LISPDIR			=	$(prefix)/share/emacs/site-lisp
INSTALLDIR		=	$(LISPDIR)/$(PACKAGE)

EL			=	text-translator.el         \
				text-translator-load.el    \
				text-translator-sites.el   \
				text-translator-vars.el    \
				text-translator-window.el

EL_EXT			=	text-translator-popup.el \
				text-translator-pos-tip.el

EL_NOT_COMPILE		=	text-translator-load.el \
				text-translator-test.el
ELC			=	$(EL:.el=.elc)

ELC_EXT			=	$(EL_EXT:.el=.elc)

DISTDIR			=	$(PACKAGE)-$(VERSION)
TARBALL			=	$(PACKAGE)-$(VERSION).tar.gz
FILES			=	Makefile README.en README.ja $(EL) $(EL_EXT) $(EL_NOT_COMPILE)

BATCH_FLAGS		=	-batch -q -no-site-file


all : compile-el

el_all : compile-el compile-el-ext

compile-el : $(ELC)

compile-el-ext : $(ELC_EXT)

install : compile-el
	@if [ ! -d $(INSTALLDIR) ]; then \
		$(MKDIR) $(INSTALLDIR); \
	fi
	$(INSTALL) -m 644 $(EL) $(ELC) $(EL_NOT_COMPILE) $(INSTALLDIR)

clean :
	-$(RM) $(ELC) $(ELC_EXT) *.patch.gz $(PACKAGE)-*.tar.gz $(PACKAGE)-*.tar.bz2

tarball: Makefile
	$(MAKE) VERSION=`$(EMACS) $(BATCH_FLAGS)            \
		-eval '(add-to-list (quote load-path) ".")' \
		-l text-translator-vars.el                  \
		-eval '(princ text-translator-version)' 2> /dev/null` dist

dist : $(FILES)
	@$(MKDIR) $(DISTDIR)
	-@cp -a $(FILES) $(DISTDIR)
	tar -zcf $(TARBALL) $(DISTDIR)
	-@$(RM) -r $(DISTDIR)

patch :
	@for file in $(FILES) ; \
	do \
		patch=$$file.patch ; \
		cvs diff $$file > $$patch ; \
		if [ -s $$patch ] ; then \
			gzip -f $$patch ; \
		else \
			$(RM) $$patch ; \
		fi \
	done

test :
	$(EMACS) $(BATCH_FLAGS)                               \
		-eval '(setq load-path (cons "." load-path))' \
		-l text-translator-test                       \
		-eval '(text-translator-test)' 2> /dev/null

%.elc: %.el
	$(EMACS) $(BATCH_FLAGS) \
		-eval '(setq load-path (cons "." load-path))' -f batch-byte-compile $<
