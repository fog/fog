module Fog
  module CDN

    def self.[](provider)
      self.new(:provider => provider)
    end

    def self.new(attributes)
      attributes = attributes.dup # prevent delete from having side effects
      provider = attributes.delete(:provider).to_s.downcase.to_sym
      if self.providers.include?(provider)
        require "fog/#{provider}/cdn"
        return Fog::CDN.const_get(Fog.providers[provider]).new(attributes)
      end
      raise ArgumentError.new("#{provider} is not a recognized cdn provider")
    end

    def self.providers
      Fog.services[:cdn]
    end

  end
end
