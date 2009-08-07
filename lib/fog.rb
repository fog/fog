require "#{File.dirname(__FILE__)}/fog/aws"

module Fog

  def self.mocking=(new_mocking)
    @mocking = new_mocking
  end

  def self.mocking?
    !!@mocking
  end

end
