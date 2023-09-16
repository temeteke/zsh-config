PREFIX := ~
FILES := .zshenv .zshrc

PMY_VERSION := 0.7.0
PMY_TARGET := Linux_x86_64
PMY_TAR_NAME := pmy_$(PMY_VERSION)_$(PMY_TARGET)
PMY_TAR_FILE := $(PMY_TAR_NAME).tar.gz
PMY_TAR_URL := https://github.com/relastle/pmy/releases/download/v$(PMY_VERSION)/$(PMY_TAR_FILE)

XDG_CONFIG_HOME ?= ${HOME}/.config
PMY_RULE_PATH := $(XDG_CONFIG_HOME)/pmy/rules
PMY_SNIPPET_PATH := $(XDG_CONFIG_HOME)/pmy/snippets
PMY_LOG_PATH := $(XDG_CACHE_HOME)/pmy/log.txt

.PHONY: all clean install uninstall FORCE
all: .zshrc

ZSHRCS := .zshrc.misc .zshrc.fzf shell-config/alias.sh pmy_env .zshrc.pmy
ifneq ($(shell which starship 2>/dev/null),)
	ZSHRCS := $(ZSHRCS) .zshrc.starship
endif
ifneq ($(shell which kubectl 2>/dev/null),)
	ZSHRCS := $(ZSHRCS) .zshrc.kubectl
endif

.zshrc: $(ZSHRCS)
	cat $^ > $@

shell-config/alias.sh: shell-config

shell-config: FORCE
	git clone --depth 1 https://github.com/temeteke/shell-config.git $@ 2> /dev/null || git -C $@ pull

pmy: $(PMY_TAR_FILE)
	tar -xf $< pmy

$(PMY_TAR_FILE):
	curl -L -o $@ $(PMY_TAR_URL)

pmy_env:
	echo export PMY_RULE_PATH="$(PMY_RULE_PATH)" > $@
	echo export PMY_SNIPPET_PATH="$(PMY_SNIPPET_PATH)" >> $@
	echo export PMY_LOG_PATH="$(PMY_LOG_PATH)" >> $@

clean:
	rm -f .zshrc pmy $(PMY_TAR_FILE) pmy_env

install: $(FILES) pmy
	cp $(FILES) $(PREFIX)/
	cp pmy ~/.local/bin/
	mkdir -p $(PMY_RULE_PATH)
	cp pmy_rules.yml $(PMY_RULE_PATH)

uninstall:
	rm -f $(addprefix $(PREFIX)/, $(FILES))
	rm -f ~/.local/bin/pmy
	rm -fr $(PMY_RULE_PATH)

FORCE:
