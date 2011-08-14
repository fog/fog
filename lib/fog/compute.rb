module Fog
  module Compute

    def self.[](provider)
      self.new(:provider => provider)
    end

    def self.new(attributes)
      attributes = attributes.dup # prevent delete from having side effects
      case provider = attributes.delete(:provider).to_s.downcase.to_sym
      when :aws
        require 'fog/compute/aws'
        Fog::Compute::AWS.new(attributes)
      when :bluebox
        require 'fog/compute/bluebox'
        Fog::Compute::Bluebox.new(attributes)
      when :brightbox
        require 'fog/compute/brightbox'
        Fog::Compute::Brightbox.new(attributes)
      when :ecloud
        require 'fog/compute/ecloud'
        Fog::Compute::Ecloud.new(attributes)
      when :gogrid
        require 'fog/compute/go_grid'
        Fog::Compute::GoGrid.new(attributes)
      when :linode
        require 'fog/compute/linode'
        Fog::Compute::Linode.new(attributes)
      when :newservers
        require 'fog/compute/new_servers'
        Fog::Compute::NewServers.new(attributes)
      when :ninefold
        require 'fog/compute/ninefold'
        Fog::Compute::Ninefold.new(attributes)
      when :rackspace
        require 'fog/compute/rackspace'
        Fog::Compute::Rackspace.new(attributes)
      when :slicehost
        require 'fog/compute/slicehost'
        Fog::Compute::Slicehost.new(attributes)
      when :stormondemand
        require 'fog/compute/storm_on_demand'
        Fog::Compute::StormOnDemand.new(attributes)
      when :vcloud
        require 'fog/compute/vcloud'
        Fog::Vcloud::Compute.new(attributes)
      when :virtualbox
        require 'fog/compute/virtual_box'
        Fog::Compute::VirtualBox.new(attributes)
      when :voxel
        require 'fog/compute/voxel'
        Fog::Compute::Voxel.new(attributes)
      else
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
