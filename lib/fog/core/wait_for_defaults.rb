module Fog
  @interval = 1
  def self.interval
    @interval
  end

  def self.interval=(interval)
    raise ArgumentError, "interval must be non-negative" unless interval >= 0
    @interval = interval
  end
  
  @timeout = 600
  def self.timeout
    @timeout
  end

  def self.timeout=(timeout)
    raise ArgumentError, "timeout must be non-negative" unless timeout >= 0
    @timeout = timeout
  end
end
