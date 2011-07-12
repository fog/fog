module Fog
  def self.timeout
    @timeout ||= 600
  end

  def self.timeout=(timeout)
    raise ArgumentError, "timeout must be non-negative" unless timeout >= 0
    @timeout = timeout
  end
end
