module Fog
  module Network

    def self.[](provider)
      self.new(:provider => provider)
    end

    def self.new(attributes)
      attributes = attributes.dup # Prevent delete from having side effects
      provider = attributes.delete(:provider).to_s.downcase.to_sym

      case provider
      when :openstack
        require 'fog/openstack/network'
        Fog::Network::OpenStack.new(attributes)
      else
        raise ArgumentError.new("#{provider} has no network service")
      end
    end

    def self.providers
      Fog.services[:network]
    end

  end
end