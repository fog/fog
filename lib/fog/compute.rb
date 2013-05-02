module Fog
  module Compute

    def self.[](provider)
      self.new(:provider => provider)
    end

    def self.new(attributes)
      attributes = attributes.dup # prevent delete from having side effects
      provider = attributes.delete(:provider).to_s.downcase.to_sym


      case provider
      when :gogrid
        require 'fog/go_grid/compute'
        Fog::Compute::GoGrid.new(attributes)
      when :new_servers
        require 'fog/bare_metal_cloud/compute'
        Fog::Logger.deprecation "`new_servers` is deprecated. Please use `bare_metal_cloud` instead."
        Fog::Compute::BareMetalCloud.new(attributes)
      when :baremetalcloud
        require 'fog/bare_metal_cloud/compute'
        Fog::Compute::BareMetalCloud.new(attributes)
      when :rackspace
        version = attributes.delete(:version) 
        version = version.to_s.downcase.to_sym unless version.nil?
        if version == :v2
          require 'fog/rackspace/compute_v2'
           Fog::Compute::RackspaceV2.new(attributes)
        else
          Fog::Logger.deprecation "First Gen Cloud Servers are deprecated. Please use `:version => :v2` attribute to use Next Gen Cloud Servers."
          require 'fog/rackspace/compute'
          Fog::Compute::Rackspace.new(attributes)
        end
      when :stormondemand
        require 'fog/storm_on_demand/compute'
        Fog::Compute::StormOnDemand.new(attributes)
      when :vcloud
        require 'fog/vcloud/compute'
        Fog::Vcloud::Compute.new(attributes)
      else
        if self.providers.include?(provider)
          require "fog/#{provider}/compute"
          return Fog::Compute.const_get(Fog.providers[provider]).new(attributes)
        end
        raise ArgumentError.new("#{provider} is not a recognized compute provider")
      end
    end

    def self.providers
      Fog.services[:compute]
    end

    def self.servers
      servers = []
      for provider in self.providers
        begin
          servers.concat(self[provider].servers)
        rescue # ignore any missing credentials/etc
        end
      end
      servers
    end

  end
end
