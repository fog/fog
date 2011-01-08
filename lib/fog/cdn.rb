module Fog
  class CDN

    def self.new(attributes)
      attributes = attributes.dup # prevent delete from having side effects
      case provider = attributes.delete(:provider)
      when 'AWS'
        require 'fog/aws'
        Fog::AWS::CDN.new(attributes)
      when 'Rackspace'
        require 'fog/rackspace'
        Fog::Rackspace::CDN.new(attributes)
      else
        raise ArgumentError.new("#{provider} is not a recognized storage provider")
      end
    end

  end
end
