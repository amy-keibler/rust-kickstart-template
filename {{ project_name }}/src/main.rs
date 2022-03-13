{%- if application_type == "empty" -%}
fn main() {
    println!("Hello, Amy!");
}
{%- elif application_type == "cli" -%}
use clap::Parser;

mod cli;

use cli::Args;

fn main() -> eyre::Result<()> {
    let _args = Args::parse();

    tracing_subscriber::fmt::init();
    color_eyre::install()?;
    println!("Hello, Amy!");

    Ok(())
}
{%- endif %}
