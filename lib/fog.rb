module Fog

  def self.mocking=(new_mocking)
    old_mocking = @mocking
    @mocking = new_mocking
    unless old_mocking == new_mocking
      self.reload
    end
  end

  def self.mocking?
    !!@mocking
  end

  def self.reload
    load "#{File.dirname(__FILE__)}/fog/aws.rb"
  end

end

Fog.reload
