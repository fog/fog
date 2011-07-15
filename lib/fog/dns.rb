module Fog
  module DNS

    def self.[](provider)
      self.new(:provider => provider)
    end

    def self.new(attributes)
      attributes = attributes.dup # prevent delete from having side effects
      case provider = attributes.delete(:provider).to_s.downcase.to_sym
      when :aws
        require 'fog/dns/aws'
        Fog::DNS::AWS.new(attributes)
      when :bluebox
        require 'fog/dns/bluebox'
        Fog::DNS::Bluebox.new(attributes)
      when :dnsimple
        require 'fog/dns/dnsimple'
        Fog::DNS::DNSimple.new(attributes)
      when :dnsmadeeasy
        require 'fog/dns/dnsmadeeasy'
        Fog::DNS::DNSMadeEasy.new(attributes)
      when :dynect
        require 'fog/dns/dynect'
        Fog::DNS::Dynect.new(attributes)
      when :linode
        require 'fog/dns/linode'
        Fog::DNS::Linode.new(attributes)
      when :slicehost
        require 'fog/dns/slicehost'
        Fog::DNS::Slicehost.new(attributes)
      when :zerigo
        require 'fog/dns/zerigo'
        Fog::DNS::Zerigo.new(attributes)
      else
        raise ArgumentError.new("#{provider} is not a recognized dns provider")
      end
    end

    def self.providers
      Fog.services[:dns]
    end

    def self.zones
      zones = []
      for provider in self.providers
        begin
          zones.concat(self[provider].zones)
        rescue # ignore any missing credentials/etc
        end
      end
      zones
    end

  end
end
