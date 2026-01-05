{
  description = "{{ project_description }}";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    crane = {
      url = "github:ipetkov/crane";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs = { self, nixpkgs, flake-utils, crane, rust-overlay, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ (import rust-overlay) ];
        };

        rustToolchain = pkgs.rust-bin.stable.latest.default.override {
          extensions = [ "rust-analyzer" "rust-src" ];
        };

        craneLib = (crane.mkLib pkgs).overrideToolchain rustToolchain;

        src = craneLib.cleanCargoSource (craneLib.path ./.);

        commonArgs = {
          inherit src;

          # uncomment if the project is a workspace
          # pname = "{{ project_name }}";
          # version = "0.1.0";
        };

        cargoArtifacts = craneLib.buildDepsOnly commonArgs;

        {{ project_name }} = craneLib.buildPackage (commonArgs // {
          inherit cargoArtifacts;
        });
      in
      rec {
        checks = {
          inherit {{ project_name }};

          nextest = craneLib.cargoNextest (commonArgs // {
            inherit cargoArtifacts;
            partitions = 1;
            partitionType = "count";
          });

          clippy = craneLib.cargoClippy (commonArgs // {
            inherit cargoArtifacts;
          });

          doc = craneLib.cargoDoc (commonArgs // {
            inherit cargoArtifacts;
          });

          fmt = craneLib.cargoFmt (commonArgs // {
            inherit src;
          });
        };

        packages.{{ project_name }} = {{ project_name }};
        packages.default = packages.{{ project_name }};

        # uncomment if there is a binary to be run
        # apps.{{ project_name }} = flake-utils.lib.mkApp {
        #   drv = packages.{{ project_name }};
        #   name = "{{ project_name }}";
        # };
        # apps.default = apps.{{ project_name }};

        devShells.default = pkgs.mkShell {
          inputsFrom = builtins.attrValues self.checks.${system};

          packages = with pkgs; [
            rustToolchain
            cargo-edit
            cargo-msrv
            cargo-outdated

            # Orchestration
            just

            # GitHub tooling
            gh

            # Nix tooling
            nixfmt-rfc-style
          ];
        };
      });
}
