use indicatif::{ProgressBar, ProgressStyle};

pub struct Reporter {
    spinner: ProgressBar,
}

impl Reporter {
    pub fn new() -> Self {
        let spinner = ProgressBar::new_spinner();
        spinner.set_style(
            ProgressStyle::default_spinner()
                .template("{spinner:.cyan} {msg}")
                .unwrap(),
        );
        spinner.enable_steady_tick(std::time::Duration::from_millis(100));
        Self { spinner }
    }

    pub fn status(&self, msg: impl Into<String>) {
        self.spinner.set_message(msg.into());
    }

    pub fn log(&self, line: &str) {
        self.spinner.suspend(|| {
            println!("  │ {}", line);
        });
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
