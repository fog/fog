__DIR__ = File.dirname(__FILE__)

$LOAD_PATH.unshift __DIR__ unless
  $LOAD_PATH.include?(__DIR__) ||
  $LOAD_PATH.include?(File.expand_path(__DIR__))

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
    load "fog/aws.rb"
  end

end

Fog.reload
