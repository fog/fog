module Fog
  module Image

    def self.[](provider)
      self.new(:provider => provider)
    end

    def self.new(attributes)
      attributes = attributes.dup # Prevent delete from having side effects
      case provider = attributes.delete(:provider).to_s.downcase.to_sym
      when :openstack
        require 'fog/openstack/image'
        Fog::Image::OpenStack.new(attributes)
      else
        raise ArgumentError.new("#{provider} has no identity service")
      end
    end

    def self.providers
      Fog.services[:image]
    end

  end
end
