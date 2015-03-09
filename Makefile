.PHONY: run test

# default inventory file
INV ?= tiad
# default play
PLAY ?= site
# default opts
ifeq ($(origin VPW), environment)
VPWF = --vault-password-file=/bin/cat
endif

# If a variable file is encrypted with Vault, either run with
# OPTS=--ask-vault-pass or do VPW=<THE_VAULT_PASSWORD> make run|test

plays := $(wildcard plays/*.yml)

help:
	@echo "make OPTION"
	@echo ""
	@echo "where OPTION is one of:"
	@echo ""
	@echo "test:  Syntax check"
	@echo "plays: List available plays"
	@echo "run:   Run a play (defaults to \"$(PLAY)\" for inventory \"$(INV)\")"

test:
	@echo $(VPW) | ansible-playbook -i inventory/$(INV) plays/$(PLAY).yml --list-hosts --list-tasks --syntax-check $(OPTS) $(VPWF)

run:
	@echo $(VPW) | ansible-playbook -i inventory/$(INV) plays/$(PLAY).yml $(OPTS) $(VPWF)

plays:
	@echo $(sort $(notdir $(plays:.yml=)))
