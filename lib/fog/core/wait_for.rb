module Fog
  def self.wait_for(timeout=Fog.timeout, interval=1, &block)
    duration = 0
    start = Time.now
    until yield || duration > timeout
      sleep(interval.to_f)
      duration = Time.now - start
    end
    if duration > timeout
      raise Errors::TimeoutError.new("The specified wait_for timeout (#{timeout} seconds) was exceeded")
    else
      { :duration => duration }
    end
  end
end
