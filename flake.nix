{
  description = "Nix User Repository";
  outputs = inputs: inputs.flake-parts.lib.mkFlake {inherit inputs;} ./module.nix;
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    flake-parts.url = github:hercules-ci/flake-parts;
    systems.url = github:nix-systems/default;

    # Packages
    gradle2nix.url = github:tadfisher/gradle2nix/v2;
    gradle2nix.inputs.nixpkgs.follows = "nixpkgs";
  };
}
