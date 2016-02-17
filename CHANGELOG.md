# Change Logs

## Versions

### 0.1.5
- Rename `#mkpath` to `#mkdir_p`.
- Add following instance methods.
    - `#real_path`, `#read`, `#world_readable?`, `#world_writable?`, `#write`
- Extend `File.real_path`, `File.new`, `Dir.new` for `Pathname`.

### 0.1.4
- Fix an error when compiled by Crystal `0.12.0`.

### 0.1.3
- Conform `#children` and `#each_child` to **Ruby**.

### 0.1.1/0.1.2
- Fix an error in `Pathname#+`.

### 0.1.0
- Implement file path string handling methods and some other methods.
