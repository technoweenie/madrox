module Madrox
  VERSION = "0.3.0"

  class << self
    attr_accessor :root_path
    def require_libs(*files)
      files.each { |file| require(File.join(root_path, file.to_s)) }
    end

    alias require_lib require_libs
  end

  self.root_path = File.expand_path("../madrox", __FILE__)
  require_libs :structs, :repo, :entry, :timeline
end

