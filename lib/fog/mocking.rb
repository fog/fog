module Fog

  def self.mocking?
    true
  end

end

require "#{File.dirname(__FILE__)}/../fog/aws"
