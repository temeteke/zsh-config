PREFIX := ~
FILES := .zshenv .zshrc

PMY_VERSION := 0.7.0
PMY_TARGET := Linux_x86_64
PMY_TAR_NAME := pmy_$(PMY_VERSION)_$(PMY_TARGET)
PMY_TAR_FILE := $(PMY_TAR_NAME).tar.gz
PMY_TAR_URL := https://github.com/relastle/pmy/releases/download/v$(PMY_VERSION)/$(PMY_TAR_FILE)

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

pmy: $(PMY_TAR_FILE)
	tar -xf $< pmy

$(PMY_TAR_FILE):
	curl -L -o $@ $(PMY_TAR_URL)

clean:
	rm -f .zshrc pmy $(PMY_TAR_FILE)

install: $(FILES)
	cp $(FILES) $(PREFIX)/

uninstall:
	rm $(addprefix $(PREFIX)/, $(FILES))

FORCE:
