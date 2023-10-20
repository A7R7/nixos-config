.PHONY: host home update gc

host:
	sudo nixos-rebuild switch --flake . --impure

home:
	home-manager switch --flake .

update:
	nix-flake update

gc:
	# remove all generations older than 7 days
	sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d
	# garbage collect all unused nix store entries
	sudo nix store gc --debug
