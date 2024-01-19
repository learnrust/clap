use clap::{Command, FromArgMatches as _, Parser, Subcommand as _};

#[derive(Parser, Debug)]
enum Subcommands {
    Derived {
        #[arg(short, long)]
        derived_flag: bool,
    },
}

fn main() {
    let cli = Command::new("subcommand ")
    .version("1.1")
    .help_template("\
{before-help}{name} {version}
{author-with-newline}{about-with-newline}
{usage-heading} {usage}
{all-args}{after-help}
");
    // Augment with derived subcommands
    let cli = Subcommands::augment_subcommands(cli);

    let matches = cli.get_matches();
    let derived_subcommands = Subcommands::from_arg_matches(&matches)
        .map_err(|err| err.exit())
        .unwrap();
    println!("Derived subcommands: {derived_subcommands:#?}");
}
