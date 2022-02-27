{
  description = "{{ project_description }}";

  inputs = {
    utils.url = "github:numtide/flake-utils";
    naersk.url = "github:nmattia/naersk";
  };

  outputs = { self, nixpkgs, utils, naersk }:
    utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages."${system}";
      naersk-lib = naersk.lib."${system}";
    in rec {
      # `nix build`
      packages.{{ project_name }} = naersk-lib.buildPackage {
        pname = "{{ project_name }}";
        root = ./.;
        doCheck = true;
      };
      defaultPackage = packages.{{ project_name }};

      # `nix run`
      apps.{{ project_name }} = utils.lib.mkApp {
        drv = packages.{{ project_name }};
        exePath = "/bin/{{ project_name }}";
      };
      defaultApp = apps.{{ project_name }};

      # `nix develop`
      devShell = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [ rustc cargo clippy rustfmt rust-analyzer ];

        RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
      };
    });
}
