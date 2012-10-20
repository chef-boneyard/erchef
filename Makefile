DEPS=$(CURDIR)/deps

# The release branch should have a file named USE_REBAR_LOCKED
use_locked_config = $(wildcard USE_REBAR_LOCKED)
ifeq ($(use_locked_config),USE_REBAR_LOCKED)
  rebar_config = rebar.config.lock
else
  rebar_config = rebar.config
endif
REBAR = rebar -C $(rebar_config)

all: compile

compile: $(DEPS)
	@$(REBAR) compile

compile_skip:
	@$(REBAR) compile skip_deps=true

clean:
	@$(REBAR) clean

# clean and allclean do the same thing now. Leaving allclean for now
# in case there are scripts that depend on it.
allclean:
	@$(REBAR) clean

update: compile
	@cd rel/erchef;bin/erchef restart

distclean: relclean
	@rm -rf deps
	@$(REBAR) clean

tags: TAGS

TAGS:
	find deps -name "*.[he]rl" -print | etags -

prepare_release: remove_lock distclean rel update_locked_config set_lock
	@$(REBAR) bump-rel-version

remove_lock:
	@rm -f USE_REBAR_LOCKED

set_lock:
	@touch USE_REBAR_LOCKED

update_locked_config:
	@rebar lock-deps ignore=meck skip_deps=true

rel: rel/erchef

devrel: rel
	@/bin/echo -n Symlinking deps and apps into release
	@$(foreach dep,$(wildcard deps/*), /bin/echo -n .;rm -rf rel/erchef/lib/$(shell basename $(dep))-* \
	   && ln -sf $(abspath $(dep)) rel/erchef/lib;)
	@/bin/echo done.
	@/bin/echo  Run \'make update\' to pick up changes in a running VM.

rel/erchef: compile
	@/bin/echo 'building OTP release package for'
	@/bin/echo '                _          _  '
	@/bin/echo '               | |        | | '
	@/bin/echo ' _   ,_    __  | |     _  | | '
	@/bin/echo '|/  /  |  /    |/ \   |/  |/  '
	@/bin/echo '|__/   |_/\___/|   |_/|__/|__/'
	@/bin/echo '                          |\  '
	@/bin/echo '                          |/  '
	@/bin/echo
	@/bin/echo "using rebar as: $(REBAR)"
	@$(REBAR) generate

relclean:
	@rm -rf rel/erchef

$(DEPS):
	@echo "Fetching deps as: $(REBAR)"
	@$(REBAR) get-deps

.PHONY: distclean remove_lock set_lock prepare_release update_locked_config update clean compile compile_skip allclean tags relclean
