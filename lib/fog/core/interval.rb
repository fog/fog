module Fog
  @interval = 1
  def self.interval
    @interval
  end

  def self.interval=(interval)
    raise ArgumentError, "interval must be non-negative" unless interval >= 0
    @interval = interval
  end
end
