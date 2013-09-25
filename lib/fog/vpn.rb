module Fog
  module VPN

    def self.[](provider)
      self.new(:provider => provider)
    end

    def self.new(attributes)
      attributes = attributes.dup
      provider = attributes.delete(:provider).to_s.downcase.to_sym

      if provider == :stormondemand
        require 'fog/storm_on_demand/vpn'
        Fog::VPN::StormOnDemand.new(attributes)
      else
        raise ArgumentError.new("#{provider} has no vpn service")
      end
    end

    def self.providers
      Fog.services[:vpn]
    end

  end
end
