module Fog

  @mocking = false

  def self.mock!
    @mocking = true
  end

  def self.mock?
    @mocking
  end

  def self.mocking?
    @mocking
  end

  module Mock
    @delay = 1
    def self.delay
      @delay
    end

    def self.delay=(new_delay)
      raise ArgumentError, "delay must be non-negative" unless new_delay >= 0
      @delay = new_delay
    end

    def self.not_implemented
      raise Fog::Errors::MockNotImplemented.new("Contributions welcome!")
    end

  end

end