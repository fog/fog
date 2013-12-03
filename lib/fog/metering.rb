module Fog
  module Metering

    def self.[](provider)
      self.new(:provider => provider)
    end

    def self.new(attributes)
      attributes = attributes.dup # Prevent delete from having side effects
      provider = attributes.delete(:provider).to_s.downcase.to_sym
      if self.providers.include?(provider)
        require "fog/#{provider}/metering"
        return Fog::Metering.const_get(Fog.providers[provider]).new(attributes)
      end

      raise ArgumentError.new("#{provider} has no identity service")
    end

    def self.providers
      Fog.services[:metering]
    end

  end
end

