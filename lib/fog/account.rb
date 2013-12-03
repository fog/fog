module Fog
  module Account

    def self.[](provider)
      self.new(:provider => provider)
    end

    def self.new(attributes)
      attributes = attributes.dup
      provider = attributes.delete(:provider).to_s.downcase.to_sym

      if provider == :stormondemand
        require 'fog/storm_on_demand/account'
        Fog::Account::StormOnDemand.new(attributes)
      else
        raise ArgumentError.new("#{provider} has no account service")
      end
    end

    def self.providers
      Fog.services[:account]
    end

  end
end
