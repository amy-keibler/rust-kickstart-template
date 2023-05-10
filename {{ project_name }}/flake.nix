{
  description = "{{ project_description }}";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    naersk = {
      url = "github:nmattia/naersk";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = { self, nixpkgs, utils, naersk }:
    utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages."${system}";
      naersk-lib = naersk.lib."${system}";
    in rec {
      packages.{{ project_name }} = naersk-lib.buildPackage {
        pname = "{{ project_name }}";
        root = ./.;
        doCheck = true;
      };
      packages.default = packages.{{ project_name }};

      apps.{{ project_name }} = utils.lib.mkApp {
        drv = packages.{{ project_name }};
        exePath = "/bin/{{ project_name }}";
      };
      apps.default = apps.{{ project_name }};

      devShells.default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          cargo
          cargo-edit
          cargo-outdated
          clippy
          rustc
          rustfmt
          rust-analyzer
        ];

        RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
      };
    });
}
