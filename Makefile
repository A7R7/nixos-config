
.PHONY: commit host/build host/generation home/build home/generation update gc

commit:
	$(eval MESSAGE := $(shell awk 'NF { printf "%s ", $$0 } END { print "" }' generation.toml))
	git commit -am "$(MESSAGE)"

host/build:
	sudo nixos-rebuild switch --flake . --impure

host/generation:
	$(eval HOST_GENERATION := $(shell sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | grep current | awk '{print $$1}'))
	@sed -i 's/host = .*/host = $(HOST_GENERATION)/' generation.toml
	@echo "Current host generation is "$(HOST_GENERATION)

host: host/build host/generation commit

home/build:
	home-manager switch --flake .

home/generation:
	$(eval HOME_GENERATION := $(shell home-manager generations | grep -oP 'id \K\d+' | head -n 1))
	@sed -i 's/home = .*/home = $(HOME_GENERATION)/' generation.toml
	@echo "Current home generation is "$(HOME_GENERATION)

home: home/build home/generation commit

update:
	nix flake update

gc:
	# remove all generations older than 7 days
	sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d
	# garbage collect all unused nix store entries
	sudo nix store gc --debug

all: host/build host/generation home/build home/generation commit
