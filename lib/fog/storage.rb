module Fog
  class Storage

    def self.new(attributes)
      attributes = attributes.dup # prevent delete from having side effects
      case provider = attributes[:provider] # attributes.delete(:provider)
      when 'AWS'
        require 'fog/storage/aws'
        Fog::AWS::Storage.new(attributes)
      when 'Google'
        require 'fog/storage/google'
        Fog::Google::Storage.new(attributes)
      when 'Local'
        require 'fog/storage/local'
        Fog::Local::Storage.new(attributes)
      when 'Rackspace'
        require 'fog/storage/rackspace'
        Fog::Rackspace::Storage.new(attributes)
      else
        raise ArgumentError.new("#{provider} is not a recognized storage provider")
      end
    end

  end
end