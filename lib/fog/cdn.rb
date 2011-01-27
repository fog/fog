module Fog
  class CDN

    def self.new(attributes)
      attributes = attributes.dup # prevent delete from having side effects
      case provider = attributes[:provider] # attributes.delete(:provider)
      when 'AWS'
        require 'fog/cdn/aws'
        Fog::AWS::CDN.new(attributes)
      when 'Rackspace'
        require 'fog/cdn/rackspace'
        Fog::Rackspace::CDN.new(attributes)
      else
        raise ArgumentError.new("#{provider} is not a recognized cdn provider")
      end
    end

  end
end
