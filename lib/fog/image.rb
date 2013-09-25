module Fog
  module Image

    def self.[](provider)
      self.new(:provider => provider)
    end

    def self.new(attributes)
      attributes = attributes.dup # Prevent delete from having side effects
      provider = attributes.delete(:provider).to_s.downcase.to_sym
      if self.providers.include?(provider)
        require "fog/#{provider}/image"
        return Fog::Image.const_get(Fog.providers[provider]).new(attributes)
      end
      raise ArgumentError.new("#{provider} has no identity service")
    end

    def self.providers
      Fog.services[:image]
    end

  end
end
