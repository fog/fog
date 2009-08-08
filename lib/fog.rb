module Fog

  def self.mocking?
    false
  end

end

require "#{File.dirname(__FILE__)}/fog/aws"
