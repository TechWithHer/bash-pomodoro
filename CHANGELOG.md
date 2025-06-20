# Changelog

## [v0.1.0] - 2025-06-20
### Added
- Basic Pomodoro functionality (Work, Break, Cycle)
- Terminal output with colors
- Timer countdown using `sleep`
- `notify-send` for alerts or terminal bell as fallback

### Known Limitations
- No logging or stats
- No config file
- No CLI help or flags

## [v0.2.0] - 2025-06-21
### Added
- `--help` flag to show usage instructions
- Input validation for minutes and cycles
- Function to check positive integers

### Changed
- Improved error messages
- Cleaner Bash syntax
- Inline comments for better understanding
  
## [v1.0.0] - 2025-06-21
### Added
- Config file support via `~/.pomodoro.conf`
- `--silent` flag to disable beeps/notifications
- `--log` flag to enable logging to `logs/`
- Daily logs saved as `session-YYYY-MM-DD.log`

### Changed
- Command-line arguments override config
- Help message improved and includes defaults
