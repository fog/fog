require 'fog/aws'
require 'fog/google'
require 'fog/local'
require 'fog/rackspace'

module Fog
  class Storage

    def self.new(attributes)
      attributes = attributes.dup # prevent delete from having side effects
      case provider = attributes.delete(:provider)
      when 'AWS'
        require 'fog/aws'
        Fog::AWS::Storage.new(attributes)
      when 'Google'
        require 'fog/google'
        Fog::Google::Storage.new(attributes)
      when 'Local'
        require 'fog/local'
        Fog::Local::Storage.new(attributes)
      when 'Rackspace'
        require 'fog/rackspace'
        Fog::Rackspace::Storage.new(attributes)
      else
        raise ArgumentError.new("#{provider} is not a recognized storage provider")
      end
    end

  end
end