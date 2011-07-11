module Fog

    @timeout = 600
    def self.timeout
      @timeout
    end

    def self.timeout=(new_timeout)
      raise ArgumentError, "timeout must be non-negative" unless new_timeout >= 0
      @timeout = new_timeout
    end

end
