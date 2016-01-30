
struct Pathname
  include Comparable(self)

  VERSION = "0.1.0"

  def self.cwd
    self.new(Dir.current)
  end

  def self.glob(*patterns)
    Dir.glob(patterns) do |path|
      yield self.new(path)
    end
  end

  def self.glob(*patterns)
    Dir.glob(patterns).map {|path| self.new(path) }
  end

  def self.glob(patterns : Enumerable(String))
    Dir.glob(patterns) do |path|
      yield self.new(path)
    end
  end

  def self.glob(patterns : Enumerable(String))
    Dir.glob(patterns).map {|path| self.new(path) }
  end


  def initialize(path : String)
    @path : String
    path = path.sub(/#{File::SEPARATOR_STRING}+$/, "") unless path == File::SEPARATOR_STRING
    @path = path
  end

  def initialize(path : Pathname)
    initialize(path.to_s)
  end

  def +(other : Pathname) : Pathname
    if other.absolute?
      other
    else
      Pathname("#{self}#{File::SEPARATOR_STRING}#{other}")
    end
  end

  def +(other : String) : Pathname
    self + Pathname.new(other)
  end

  def /(other : Pathname) : Pathname
    self + other.to_s
  end

  def /(other : String) : Pathname
    self + other
  end

  def <=>(other : Pathname)
    @path <=> other.@path
  end

  def ===(other : Pathname)
    cleanpath == other.cleanpath
  end

  def absolute? : Bool
    @path.starts_with?(File::SEPARATOR_STRING)
  end

  def ascend
    mfnames = filenames
    0.upto(mfnames.size - 1).each do |i|
      new_path = mfnames[0..i].join(File::SEPARATOR_STRING)
      new_path = "#{File::SEPARATOR_STRING}#{new_path}" if new_path.empty?
      yield Pathname.new(new_path)
    end
  end

  def atime : Time
    File.stat(@path).atime
  end

  def basename : Pathname
    Pathname.new(File.basename(@path))
  end

  def basename(suffix : String) : Pathname
    pattern = "#{suffix.gsub(/\./, "\\.").gsub(/\*/, "[^\\.]+")}$"
    new_path = File.basename(@path)
    new_path = new_path.sub(Regex.new(pattern), "") if new_path =~ /[^\.]\.[^\.]/
    Pathname.new(new_path)
  end

  # def binread
  # def binwrite
  # def birthtime

  def blockdev? : Bool
    File.stat(@path).blockdev?
  end

  def chardev? : Bool
    File.stat(@path).chardev?
  end

  def children(with_directory = true : Bool) : Array(Pathname)
    paths = [] of Pathname
    Dir.entries(@path).each do |entry|
      next if entry == "." || entry == ".."
      next if !with_directory && File.directory?("#{@path}#{File::SEPARATOR_STRING}#{entry}")
      paths << Pathname.new(entry)
    end
    paths
  end

  # def chmod
  # def chown

  def cleanpath(consider_symlink = false : Bool) : Pathname
    new_filenames = [] of String
    filenames.each do |node|
      case node
      when "", "."
      when ".."
        if new_filenames.empty?
          new_filenames << node if relative?
        else
          if new_filenames.last == ".."
            new_filenames << node
          else
            new_filenames.pop
          end
        end
      else
        new_filenames << node
      end
    end
    new_path = new_filenames.join(File::SEPARATOR_STRING)
    if new_path.empty?
      new_path = (absolute? ? "/" : ".")
    end
    new_path = "/#{new_path}" if absolute? && new_path !~ /^#{File::SEPARATOR_STRING}/
    Pathname.new(new_path)
  end

  def ctime : Time
    File.stat(@path).ctime
  end

  def delete
    File.delete(@path)
  end

  def descend
    mfnames = filenames
    (mfnames.size - 1).downto(0).each do |i|
      new_path = mfnames[0..i].join(File::SEPARATOR_STRING)
      new_path = "#{File::SEPARATOR_STRING}#{new_path}" if new_path.empty?
      yield Pathname.new(new_path)
    end
  end

  def directory? : Bool
    File.directory?(@path)
  end

  def dirname : Pathname
    Pathname.new(File.dirname(@path))
  end

  def each_child(with_directory = true : Bool)
    children(with_directory).each do |child|
      yield child
    end
  end

  def each_entry
    entries.each do |entry|
      yield entry
    end
  end

  def each_filename
    mfnames = filenames
    mfnames.shift if absolute?
    mfnames.each do |filename|
      yield filename
    end
  end

  def each_line
    File.each_line(@path) do |line|
      yield line
    end
  end

  def entries : Array[Pathname]
    ents = [] of Pathname
    Dir.entries(@path).each do |entry|
      ents << Pathname.new(entry)
    end
    ents
  end

  def executable? : Bool
    File.executable?(@path)
  end

  def exists? : Bool
    File.exists?(@path)
  end

  def expand_path(default_dir : Pathname) : Pathname
    if absolute?
      self
    else
      Pathname.new("#{default_dir}#{File::SEPARATOR_STRING}#{@path}").cleanpath
    end
  end

  def expand_path(default_dir = Dir.current : String)
    expand_path(Pathname.new(default_dir))
  end

  def extname : String
    File.extname(@path)
  end

  def file? : Bool
    stat.file?
  end

  def filenames : Array(String)
    @path.split(File::SEPARATOR_STRING)
  end

  # def find
  # def fnmatch
  # def fnmatch?
  # def ftype
  # def grpowned?

  def inspect(io)
    io << "#<Pathname:" << @path << ">"
  end

  def join(*args) : Pathname
    new_pathname = self
    args.each do |arg|
      new_pathname += arg
    end
    new_pathname
  end

  # def lchmod
  # def lchown

  def lstat
    File.lstat(@path)
  end

  def make_link(old)
    File.link(old, @path)
  end

  def make_symlink(old)
    File.symlink(old, @path)
  end

  def mkdir(mode = 0o511)
    Dir.mkdir(@path, mode)
  end

  def mkpath(mode = 0o511)
    Dir.mkdir_p(@path, mode)
  end

  # def mountpoint?

  def mtime : Time
    stat.mtime
  end

  def open(mode = "r", perm = DEFAULT_CREATE_MODE)
    File.open(@path, mode, perm)
  end

  def open(mode = "r", perm = DEFAULT_CREATE_MODE)
    File.open(@path, mode, perm) do |io|
      yield io
    end
  end

  def opendir
    Dir.open(@path)
  end

  def opendir
    Dir.open(@path) do |dir|
      yield dir
    end
  end

  def parent
    dirname
  end

  # def pipe?
  # def owned?
  # def read

  def readable?
    File.readable?(@path)
  end

  # def readable_real?
  # def readlink
  # def realdirpath
  # def realpath

  def relative?
    !absolute?
  end

  def relative_path_from(base_directory : String) : Pathname
    relative_path_from(Pathname.new(base_directory))
  end

  def relative_path_from(base_directory : Pathname) : Pathname
    if absolute? && base_directory.absolute?
      mfnames = cleanpath.filenames
      bfnames = base_directory.cleanpath.filenames
      while mfnames.first? == bfnames.first?
        mfnames.shift
        bfnames.shift
      end
      until bfnames.empty?
        bfnames.shift
        mfnames.unshift("..")
      end
      Pathname.new(mfnames.join(File::SEPARATOR_STRING))
    elsif relative? && base_directory.relative?
      Pathname.new("#{base_directory}#{File::SEPARATOR_STRING}#{@path}").cleanpath
    else
      raise "relative and absolute path."
    end
  end

  def rename(to)
    File.rename(@path, to)
  end

  def rmdir
    Dir.rmdir(@path)
  end

  # def rmtree

  def root?
    cleanpath.path == "/"
  end

  def setgid?
    stat.setgid?
  end

  def setuid?
    stat.setuid?
  end

  def size
    stat.size
  end

  def size?
    return nil unless exists?
    size == 0 ? nil : size
  end

  def socket?
    stat.socket?
  end

  def split
    {dirname, basename}
  end

  def stat
    File.stat(@path)
  end

  def sticky?
    stat.sticky?
  end

  def sub(pattern, replace) : Pathname
    Pathname.new(@path.sub(pattern, replace))
  end

  def sub(pattern)
    Pathname.new(@path.sub(pattern) { |lmatched| yield lmatched })
  end

  def sub_ext(replace : String)
    striped_path = (@path == "/" ? "" : basename(".*"))
    fnames = filenames
    fnames.pop
    fnames.push("#{striped_path}#{replace}")
    Pathname.new(fnames.join(File::SEPARATOR_STRING))
  end

  def symlink?
    File.symlink?(@path)
  end

  # def sysopen
  # def to_path

  def to_s(io)
    io << @path
  end

  # def truncate

  def utime
    stat.utime
  end

  # def world_readable?
  # def world_writable?

  def writable?
    File.writable?(@path)
  end

  # def write

  def zero?
    return false unless exists?
    size == 0
  end
end

class File

  def self.stat(path : Pathname)
    self.stat(path.to_s)
  end

  def self.lstat(path : Pathname)
    self.lstat(path.to_s)
  end

  def self.exists?(path : Pathname)
    self.exists?(path.to_s)
  end

  def self.readable?(path : Pathname)
    self.readable?(path.to_s)
  end

  def self.writable?(path : Pathname)
    self.writable?(path.to_s)
  end

  def self.executable?(path : Pathname)
    self.executable?(path.to_s)
  end

  def self.file?(path : Pathname)
    self.file?(path.to_s)
  end

  def self.directory?(path : Pathname)
    self.directory?(path.to_s)
  end

  def self.dirname(path : Pathname)
    self.dirname(path.to_s)
  end

  def self.basename(path : Pathname)
    self.basename(path.to_s)
  end

  def self.basename(path : Pathname, suffix)
    self.basename(path.to_s, suffix)
  end

  def self.delete(path : Pathname)
    self.delete(path.to_s)
  end

  def self.extname(path : Pathname)
    self.extname(path.to_s)
  end

  def self.expand_path(path : Pathname, dir = nil)
    self.expand_path(path.to_s, dir)
  end

  def self.link(old_path : Pathname, new_path)
    self.link(old_path.to_s, new_path)
  end

  def self.link(old_path, new_path : Pathname)
    self.link(old_path, new_path.to_s)
  end

  def self.link(old_path : Pathname, new_path : Pathname)
    self.link(old_path.to_s, new_path.to_s)
  end

  def self.symlink(old_path : Pathname, new_path)
    self.symlink(old_path.to_s, new_path)
  end

  def self.symlink(old_path, new_path : Pathname)
    self.symlink(old_path, new_path.to_s)
  end

  def self.symlink(old_path : Pathname, new_path : Pathname)
    self.symlink(old_path.to_s, new_path.to_s)
  end

  def self.symlink?(path : Pathname)
    self.symlink?(path.to_s)
  end

  def self.open(path : Pathname, mode = "r", perm = DEFAULT_CREATE_MODE)
    self.open(path.to_s, mode, perm)
  end

  def self.open(path : Pathname, mode = "r", perm = DEFAULT_CREATE_MODE)
    self.open(path.to_s, mode, perm) do |fd|
      yield fd
    end
  end

  def self.read(path : Pathname)
    self.read(path.to_s)
  end

  def self.each_line(path : Pathname)
    self.each_line(path.to_s) do |line|
      yield line
    end
  end

  def self.read_lines(path : Pathname)
    self.read_lines(path.to_s)
  end

  def self.write(path : Pathname, content, perm = DEFAULT_CREATE_MODE)
    self.write(path.to_s, content, perm)
  end

  def self.size(path : Pathname)
    self.size(path.to_s)
  end

  def self.rename(old_path : Pathname, new_path)
    self.rename(old_path.to_s, new_path)
  end

  def self.rename(old_path, new_path : Pathname)
    self.rename(old_path, new_path.to_s)
  end

  def self.rename(old_path : Pathname, new_path : Pathname)
    self.rename(old_path.to_s, new_path.to_s)
  end

end

class Dir

  def self.open(path : Pathname)
    self.open(path.to_s)
  end

  def self.open(path : Pathname)
    self.open(path.to_s) do |dir|
      yield dir
    end
  end

  def self.cd(path : Pathname)
    self.cd(path.to_s)
  end

  def self.cd(path : Pathname)
    self.cd(path.to_s) do
      yield
    end
  end

  def self.foreach(path : Pathname)
    self.foreach(path.to_s) do |filename|
      yield filename
    end
  end

  def self.entries(path : Pathname)
    self.entries(path.to_s)
  end

  def self.exists?(path : Pathname)
    self.exists?(path.to_s)
  end

  def self.mkdir(path : Pathname, mode = 0o777)
    self.mkdir(path.to_s, mode)
  end

  def self.mkdir_p(path : Pathname, mode = 0o777)
    self.mkdir_p(path.to_s, mode)
  end

  def self.rmdir(path : Pathname)
    self.rmdir(path.to_s)
  end

end
