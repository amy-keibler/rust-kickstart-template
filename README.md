# Rust Starter Kickstart Template

This is a [kickstart](https://github.com/Keats/kickstart) template for building a Rust application.

## Variables

### `project_name`

The name of the project in lowercase snake case form. This is used in the Cargo.toml file and flake file.

### `project_description`

The short description of the purpose of the project. This is used in the Cargo.toml file and the flake file.

### `application_type`

The intended purpose of the application. Currently, this supports a `cli`, which includes `clap` as a dependency and `empty`, which does not include an prescribed structure or dependencies.

### `license`

The license of the project. Currently supports the [Be Gay, Do Crime](https://twitter.com/scanlime/status/1304825753029107712) license and a dual-license of [MIT](https://mit-license.org/) and/or [Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0.html).

### `include_github_actions_ci`

If `true`, this will include a [Dependabot](https://docs.github.com/en/code-security/dependabot/dependabot-alerts/about-dependabot-alerts#github-dependabot-alerts-for-vulnerable-dependencies) configuration and a GitHub Action workflow that runs `nix build` and `nix flake check` on pull requests and pushes to the `main` branch.

### `add_sbom`

If `true`, adds a default configuration to the `Cargo.toml` file to be used with [`cargo-cyclonedx`](https://crates.io/crates/cargo-cyclonedx). This configures the output SBOM file created when running `cargo cyclonedx`.
