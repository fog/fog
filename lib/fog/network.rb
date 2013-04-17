module Fog
  module Network

    def self.[](provider)
      self.new(:provider => provider)
    end

    def self.new(attributes)
      attributes = attributes.dup # Prevent delete from having side effects
      provider = attributes.delete(:provider).to_s.downcase.to_sym

      if self.providers.include?(provider)
        require "fog/#{provider}/network"
        return Fog::Network.const_get(Fog.providers[provider]).new(attributes)
      end

      raise ArgumentError.new("#{provider} has no network service")
    end

    def self.providers
      Fog.services[:network]
    end

  end
end