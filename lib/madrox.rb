require 'grit'

module Madrox
  VERSION = "0.3.0"
end

%w(structs repo entry timeline).each do |file|
  require File.expand_path("../madrox/#{file}", __FILE__)
end

