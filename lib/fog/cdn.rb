module Fog
  module CDN

    def self.[](provider)
      self.new(:provider => provider)
    end

    def self.new(attributes)
      attributes = attributes.dup # prevent delete from having side effects
      case provider = attributes.delete(:provider).to_s.downcase.to_sym
      when :aws
        require 'fog/aws/cdn'
        Fog::CDN::AWS.new(attributes)
      when :rackspace
        require 'fog/rackspace/cdn'
        Fog::CDN::Rackspace.new(attributes)
      else
        raise ArgumentError.new("#{provider} is not a recognized cdn provider")
      end
    end

    def self.providers
      Fog.services[:cdn]
    end

  end
end
