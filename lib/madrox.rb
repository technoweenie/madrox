module Madrox
  VERSION = "0.1.0"
end

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'vendor', 'grit', 'lib')
require 'grit'
require 'madrox/repo'
require 'madrox/timeline'