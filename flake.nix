{
  description = "terraform-aws";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        inherit (pkgs) callPackage mkShell;

        pkgs = import nixpkgs {
          inherit system;
        };

        iamlive = callPackage ./nix/pkgs/iamlive { };

        buildInputs = with pkgs; [
          # AWS
          awscli2
          iamlive

          # Terraform
          terraform
          tflint

          # Nix
          nixpkgs-fmt

          # Utilities
          jq
        ];
      in
      rec {
        # nix develop
        devShell = mkShell {
          inherit buildInputs;
          name = "terraform-aws-shell";
        };
      });
}
