require 'pathname'

class DevHelper
  def self.project_pathname
    @@project_pathname ||= (Pathname.new(__FILE__).dirname + '../../../..').cleanpath
  end

  def self.project_dir
    self.project_pathname.realpath.to_s
  end

  def self.parent_dir
    @@parent_dir ||= (self.project_pathname.parent.cleanpath)
    @@parent_dir.realpath.to_s
  end
end
