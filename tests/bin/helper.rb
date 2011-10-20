require 'fog'
require 'fog/bin' # for available_providers

BIN = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'bin', 'fog'))

def bin(arguments)
  `#{BIN} #{arguments}`
end
