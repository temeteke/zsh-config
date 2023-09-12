PREFIX := ~
FILES := .zshenv .zshrc

.PHONY: all clean install uninstall FORCE
all: .zshrc

ZSHRCS := .zshrc.misc
ifneq ($(shell which starship 2>/dev/null),)
	ZSHRCS := $(ZSHRCS) .zshrc.starship
endif

.zshrc: $(ZSHRCS)
	cat $^ > $@

clean:
	rm -f .zshrc

install: $(FILES)
	cp $(FILES) $(PREFIX)/

uninstall:
	rm $(addprefix $(PREFIX)/, $(FILES))

FORCE:
