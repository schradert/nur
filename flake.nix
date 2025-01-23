{
  description = "Nix User Repository";
  outputs = inputs: inputs.flake-parts.lib.mkFlake {inherit inputs;} ./module.nix;
  inputs.nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
  inputs.flake-parts.url = github:hercules-ci/flake-parts;
  inputs.systems.url = github:nix-systems/default;
}
