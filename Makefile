PREFIX := ~
FILES := .zshenv .zshrc

.PHONY: all clean install uninstall FORCE
all: .zshrc

ZSHRCS := .zshrc.misc .zshrc.fzf shell-config/alias.sh
ifneq ($(shell which starship 2>/dev/null),)
	ZSHRCS := $(ZSHRCS) .zshrc.starship
endif

.zshrc: $(ZSHRCS)
	cat $^ > $@

shell-config/alias.sh: shell-config

shell-config:
	git clone --depth 1 https://github.com/temeteke/shell-config.git $@

clean:
	rm -f .zshrc

install: $(FILES)
	cp $(FILES) $(PREFIX)/

uninstall:
	rm $(addprefix $(PREFIX)/, $(FILES))

FORCE:
