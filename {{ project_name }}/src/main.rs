{%- if application_type == "empty" -%}
fn main() {
    println!("Hello, Amy!");
}
{%- elif application_type == "cli" -%}
use clap::Parser;
use tracing_subscriber::{fmt, prelude::*, EnvFilter};

mod cli;

use cli::Args;

fn main() -> eyre::Result<()> {
    let _args = Args::parse();

    tracing_subscriber::registry()
        .with(fmt::layer())
        .with(EnvFilter::from_default_env())
        .init();
    color_eyre::install()?;

    println!("Hello, Amy!");

    Ok(())
}
{%- endif %}
