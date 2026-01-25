use std::fmt::Display;

use indicatif::{ProgressBar, ProgressStyle};

pub struct Reporter {
    spinner: ProgressBar,
}

pub const TICK_CHARS: &str = "⣷⣯⣟⡿⢿⣻⣽⣾";

impl Reporter {
    pub fn new() -> Self {
        let spinner = ProgressBar::new_spinner();
        spinner.set_style(
            ProgressStyle::with_template(
                "{prefix:.dim}{msg:>8.214/yellow} {spinner} [{elapsed_precise}]",
            )
            .unwrap()
            .tick_chars(TICK_CHARS),
        );
        spinner.enable_steady_tick(std::time::Duration::from_millis(100));
        Self { spinner }
    }

    pub fn status(&self, msg: impl Into<String>) {
        self.spinner.set_message(msg.into());
    }

    pub fn log_event(&self, line: &str) {
        self.spinner.suspend(|| {
            println!("  │ {}", line);
        });
    }

    pub fn log<T: Display>(&self, text: T) {
        self.spinner.suspend(|| println!("{}", text))
    }

    pub fn success(&self, msg: &str) {
        self.spinner.finish_with_message(format!("✓ {}", msg));
    }

    pub fn fail(&self, msg: &str) {
        self.spinner.finish_with_message(format!("✗ {}", msg));
    }
}

impl Default for Reporter {
    fn default() -> Self {
        Self::new()
    }
}
