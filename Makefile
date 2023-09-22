ZDOTDIR ?= $(HOME)
BIN_DIR ?= $(HOME)/.local/bin
XDG_CONFIG_HOME ?= $(HOME)/.config

FILES := .zshenv .zshrc

PMY_VERSION := $(subst https://github.com/relastle/pmy/releases/tag/v,,$(shell curl -s -w '%{redirect_url}' https://github.com/relastle/pmy/releases/latest))
PMY_TARGET := Linux_x86_64
PMY_TAR_NAME := pmy_$(PMY_VERSION)_$(PMY_TARGET)
PMY_TAR_FILE := $(PMY_TAR_NAME).tar.gz
PMY_TAR_URL := https://github.com/relastle/pmy/releases/download/v$(PMY_VERSION)/$(PMY_TAR_FILE)
PMY_RULE_PATH := $(XDG_CONFIG_HOME)/pmy/rules
PMY_SNIPPET_PATH := $(XDG_CONFIG_HOME)/pmy/snippets
PMY_LOG_PATH := $(XDG_CACHE_HOME)/pmy/log.txt

.PHONY: all clean install uninstall FORCE
all: .zshrc pmy

ZSHRCS := .zshrc.misc .zshrc.fzf shell-config/alias.sh pmy_env .zshrc.pmy .zshrc.cursor
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

pmy: | $(PMY_TAR_FILE)
	tar -xf $(PMY_TAR_FILE) pmy

$(PMY_TAR_FILE):
	curl -LR -o $@ $(PMY_TAR_URL)

pmy_env:
	echo export PMY_RULE_PATH="$(PMY_RULE_PATH)" > $@
	echo export PMY_SNIPPET_PATH="$(PMY_SNIPPET_PATH)" >> $@
	echo export PMY_LOG_PATH="$(PMY_LOG_PATH)" >> $@

clean:
	rm -f .zshrc pmy $(PMY_TAR_FILE) pmy_env

install: install-zsh install-pmy

install-zsh: $(FILES) $(ZDOTDIR)
	mkdir -p $(ZDOTDIR)
	cp -a $(FILES) $(ZDOTDIR)/

install-pmy: pmy $(BIN_DIR)
	mkdir -p $(BIN_DIR)
	cp -a pmy $(BIN_DIR)/
	mkdir -p $(PMY_RULE_PATH)
	cp -a pmy_rules.yml $(PMY_RULE_PATH)/

uninstall: uninstall-zsh uninstall-pmy

uninstall-zsh:
	rm -f $(addprefix $(ZDOTDIR)/, $(FILES))

uninstall-pmy:
	rm -f ~/.local/bin/pmy
	rm -fr $(PMY_RULE_PATH)

FORCE:
