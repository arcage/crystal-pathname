# Pathname for Crystal

**Crystal** implementation of **Ruby**'s `Pathname` object.

## Version
- 0.1.0

    Implement file path string handling methods and some other methods.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  pathname:
    github: arcage/cerystal-pathname
```

## Usage

```crystal
require "pathname"

Pathname.new("foo/bar")  + "baz"    # => #<Pathname:foo/bar/baz>
Pathname.new("foo/bar/") + "baz"    # => #<Pathname:foo/bar/baz>
Pathname.new("foo/bar")  + "/baz"   # => #<Pathname:/baz>
Pathname.new("foo/bar")  + "../baz" # => #<Pathname:foo/baz>

Pathname.new("foo/bar")        <=> Pathname.new("foo/bar") #=>  0
Pathname.new("foo/../foo/bar") <=> Pathname.new("foo/bar") #=> -1
Pathname.new("foo/foo/../bar") <=> Pathname.new("foo/bar") #=>  1

Pathname.new("foo/bar")        ==  Pathname.new("foo/bar") #=> true
Pathname.new("foo/../foo/bar") ==  Pathname.new("foo/bar") #=> false
Pathname.new("foo/../foo/bar") === Pathname.new("foo/bar") #=> true

Pathname.new("/foo/bar").relative_path_from("/foo/buz")
#=> #<Pathname:../bar>

```

## Available Methods
### Class methods
`.cwd`, `.glob`, `new`

### Instance methods
`#+`, `#/`, `#<=>`, `#==`, `#===`, `#absolute?`, `#ascend`, `#atime`, `#basename`, `#blockdev?`, `#chardev?`, `#children`, `#cleanpath`, `#ctime`, `#delete`, `#descend`, `#directory?`, `#dirname`, `#each_child`(with block), `#each_entry`, `#each_filename`, `#each_line`(with block), `#entries`, `#executable?`, `#exists`, `#expand_path`, `#extname`, `#file?`, `#join`, `#lstat`, `#make_link`, `#make_symlink`, `#mkdir`, `#mkpath`, `#open`, `#opendir`, `#parent`, `#readable?`, `#relative?`, `#relative_path_from`, `#rename`, `#rmdir`, `#root?`, `#setgid?`, `#setuid`, `#size`, `#size?`, `#socket?`, `#split`, `#stat`, `#sticky?`, `#sub`, `#sub_ext`, `#symlink`, `#utime`, `#writable?`

## Core library extension
When calling the following methods, you can use Pathname object as filename(or dirname or pathname) parameter.

### `File` class
`File.basename`, `File.delete`, `File.directory?`, `File.dirname`, `File.each_line`, `File.exists?`, `File.executable?`, `File.expand_path`, `File.extname`, `File.file?`, `File.link`, `File.lstat`, `File.open`, `File.read`, `File.read_lines`, `File.readable?`, `File.rename`, `File.size`, `File.stat`, `File.symlink`, `File.writable?`, `File.write`

### `Dir` class
`Dir.cd`, `Dir.entries`, `Dir.exists?`, `Dir.foreach`, `Dir.mkdir`, `Dir.mkdir_p`, `Dir.open`, `Dir.rmdir`

## Differences from **Ruby**'s one.
- Consecutive `File::SEPARATOR`s (ex: "//") in a path string are always normalized in `#initilize`.
- `#===(other : Pathname)` returns `true` when `#cleanpath` results of `self` and `other` are same.
- Class method `.getwd` and `.pwd` are integrated to into `.cwd`, because they doesn't *print* anything.
- `#exists?` instead of `#exist?`.
- Following methods are unavailable(at this version).
    - top level method `Pathname()`
    - instance methods `#binread`, `#binwrite`, `#birthtime`, `#chmod`, `#chown`, `#each_child`(without block), `#each_line`(without block), `#find`, `#fnmatch`, `#fnmatch?`, `#ftype`, `#grpowned?`, `#lchmod`, `#lchown`, `#mountpoint?`, `#pipe?`, `#owned?`, `#read`, `#readable_real?`, `#readlink`, `#realdirpath`, `#realpath`, `#rmtree`, `#sysopen`, `#to_path`, `#truncate`, `#world_readable?`, `#world_writable?`, `#write`
