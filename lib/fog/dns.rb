module Fog
  class DNS

    def self.new(attributes)
      attributes = attributes.dup # prevent delete from having side effects
      case provider = attributes.delete(:provider)
      when 'AWS'
        require 'fog/aws'
        Fog::AWS::DNS.new(attributes)
      when 'Linode'
        require 'fog/linode'
        Fog::Linode::DNS.new(attributes)
      when 'Slicehost'
        require 'fog/slicehost'
        Fog::Slicehost::DNS.new(attributes)
      when 'Zerigo'
        require 'fog/zerigo'
        Fog::Zerigo::DNS.new(attributes)
      else
        raise ArgumentError.new("#{provider} is not a recognized storage provider")
      end
    end

  end
end
