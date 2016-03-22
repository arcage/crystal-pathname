# Change Logs

## Versions

### v0.1.6
- Changed the syntax of a method argument with a default value and a type restriction for Crystal `0.14`.

### v0.1.5
- Renamed `#mkpath` to `#mkdir_p`.
- Add following instance methods.
    - `#real_path`, `#read`, `#truncate`, `#world_readable?`, `#world_writable?`, `#write`
- Extend `File.real_path`, `File.new` and `Dir.new` for `Pathname`.

### v0.1.4
- Fix an error when compiled by Crystal `0.12`.

### v0.1.3
- Conform `#children` and `#each_child` to **Ruby**.

### v0.1.1/v0.1.2
- Fix an error in `Pathname#+`.

### v0.1.0
- Implement file path string handling methods and some other methods.
