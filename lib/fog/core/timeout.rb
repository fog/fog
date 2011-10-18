module Fog
  @timeout = 600
  def self.timeout
    @timeout
  end

  def self.timeout=(timeout)
    raise ArgumentError, "timeout must be non-negative" unless timeout >= 0
    @timeout = timeout
  end
end
