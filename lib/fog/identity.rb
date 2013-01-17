module Fog
  module Identity

    def self.[](provider)
      self.new(:provider => provider)
    end

    def self.new(attributes)
      attributes = attributes.dup # Prevent delete from having side effects
      case provider = attributes.delete(:provider).to_s.downcase.to_sym
      when :rackspace
        require 'fog/rackspace/identity'
        Fog::Rackspace::Identity.new(attributes)
      when :openstack
        require 'fog/openstack/identity'
        Fog::Identity::OpenStack.new(attributes)
      else
        raise ArgumentError.new("#{provider} has no identity service")
      end
    end

    def self.providers
      Fog.services[:idenity]
    end

  end
end
