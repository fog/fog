module Fog
  module Monitoring

    def self.[](provider)
      self.new(:provider => provider)
    end

    def self.new(attributes)
      attributes = attributes.dup
      provider = attributes.delete(:provider).to_s.downcase.to_sym
      if provider == :stormondemand
        require 'fog/storm_on_demand/billing'
        Fog::Monitoring::StormOnDemand.new(attributes)
      else
        raise ArgumentError.new("#{provider} has no monitoring service")
      end
    end

    def self.providers
      Fog.services[:monitoring]
    end

  end
end
