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

prepare_release: distclean unlocked_deps unlocked_compile update_locked_config rel
	@echo 'release prepared, bumping version'
	@$(REBAR) bump-rel-version

unlocked_deps:
	@echo 'Fetching deps as: rebar -C rebar.config'
	@rebar -C rebar.config get-deps

# When running the prepare_release target, we have to ensure that a
# compile occurs using the unlocked rebar.config. If a dependency has
# been removed, then using the locked version that contains the stale
# dep will cause a compile error.
unlocked_compile:
	@rebar -C rebar.config compile

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
	@/bin/echo 'building OTP release package for erchef'
	@/bin/echo "using rebar as: $(REBAR)"
	@$(REBAR) generate
	@/bin/echo '                _          _  '
	@/bin/echo '               | |        | | '
	@/bin/echo ' _   ,_    __  | |     _  | | '
	@/bin/echo '|/  /  |  /    |/ \   |/  |/  '
	@/bin/echo '|__/   |_/\___/|   |_/|__/|__/'
	@/bin/echo '                          |\  '
	@/bin/echo '                          |/  '
	@/bin/echo

relclean:
	@rm -rf rel/erchef

$(DEPS):
	@echo "Fetching deps as: $(REBAR)"
	@$(REBAR) get-deps

ifeq ($(wildcard chef/dev_config.json), chef/dev_config.json)
  CHEF_ATTRS = -j chef/dev_config.json
else
  CHEF_ATTRS =
endif

clone_for_dev:
	chef-solo -c chef/solo.rb $(CHEF_ATTRS) -o 'recipe[dev::setup]'

.PHONY: distclean remove_lock set_lock prepare_release update_locked_config update clean compile compile_skip allclean tags relclean unlocked_deps
