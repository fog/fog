module Fog
  class DNS

    def self.new(attributes)
      attributes = attributes.dup # prevent delete from having side effects
      case provider = attributes[:provider] # attributes.delete(:provider)
      when 'AWS'
        require 'fog/dns/aws'
        Fog::AWS::DNS.new(attributes)
      when 'Bluebox'
        require 'fog/dns/bluebox'
        Fog::Bluebox::DNS.new(attributes)
      when 'DNSimple'
        require 'fog/dns/dnsimple'
        Fog::DNSimple::DNS.new(attributes)
      when 'Linode'
        require 'fog/dns/linode'
        Fog::Linode::DNS.new(attributes)
      when 'Slicehost'
        require 'fog/dns/slicehost'
        Fog::Slicehost::DNS.new(attributes)
      when 'Zerigo'
        require 'fog/dns/zerigo'
        Fog::Zerigo::DNS.new(attributes)
      else
        raise ArgumentError.new("#{provider} is not a recognized dns provider")
      end
    end

  end
end
