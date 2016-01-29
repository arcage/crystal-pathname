require "./spec_helper"

describe Pathname do

  context ".cwd" do
    it "returns Pathname object of the current working directory" do
      cwd = Pathname.cwd
      cwd.is_a?(Pathname).should be_true
      cwd.to_s.should eq Dir.current
    end
  end

  context ".glob" do
    it "returns an array of Pathname when without block" do
      glob = Pathname.glob("/*")
      glob.is_a?(Array(Pathname)).should be_true
      glob.map(&.to_s).should eq Dir.glob("/*")
    end

    it "works as an iterator" do
      dir_glob = Dir.glob("/*")
      Pathname.glob("/*") do |path|
        path.is_a?(Pathname).should be_true
        path.to_s.should eq dir_glob.shift
      end
      dir_glob.empty?.should be_true
    end
  end

  context ".new" do
    it "parses an absolute path" do
      path_string = "/var/log"
      path = Pathname.new(path_string)
      path.to_s.should eq path_string
      path.absolute?.should be_true
    end
    it "parses a relative path" do
      path_string = "www/htdocs"
      path = Pathname.new(path_string)
      path.to_s.should eq path_string
      path.relative?.should be_true
    end
  end

end
