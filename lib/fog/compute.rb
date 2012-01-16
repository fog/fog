module Fog
  module Compute

    def self.[](provider)
      self.new(:provider => provider)
    end

    def self.new(attributes)
      attributes = attributes.dup # prevent delete from having side effects
      case provider = attributes.delete(:provider).to_s.downcase.to_sym
      when :aws
        require 'fog/aws/compute'
        Fog::Compute::AWS.new(attributes)
      when :bluebox
        require 'fog/bluebox/compute'
        Fog::Compute::Bluebox.new(attributes)
      when :brightbox
        require 'fog/brightbox/compute'
        Fog::Compute::Brightbox.new(attributes)
      when :cloudstack
        require 'fog/cloudstack/compute'
        Fog::Compute::Cloudstack.new(attributes)
      when :clodo
        require 'fog/clodo/compute'
        Fog::Compute::Clodo.new(attributes)
      when :ecloud
        require 'fog/ecloud/compute'
        Fog::Compute::Ecloud.new(attributes)
      when :glesys
        require 'fog/glesys/compute'
        Fog::Compute::Glesys.new(attributes)
      when :gogrid
        require 'fog/go_grid/compute'
        Fog::Compute::GoGrid.new(attributes)
      when :libvirt
        require 'fog/libvirt/compute'
        Fog::Compute::Libvirt.new(attributes)
      when :linode
        require 'fog/linode/compute'
        Fog::Compute::Linode.new(attributes)
      when :newservers
        require 'fog/new_servers/compute'
        Fog::Compute::NewServers.new(attributes)
      when :ninefold
        require 'fog/ninefold/compute'
        Fog::Compute::Ninefold.new(attributes)
      when :openstack
        require 'fog/openstack/compute'
        Fog::Compute::OpenStack.new(attributes)
      when :rackspace
        require 'fog/rackspace/compute'
        Fog::Compute::Rackspace.new(attributes)
      when :slicehost
        require 'fog/slicehost/compute'
        Fog::Compute::Slicehost.new(attributes)
      when :stormondemand
        require 'fog/storm_on_demand/compute'
        Fog::Compute::StormOnDemand.new(attributes)
      when :vcloud
        require 'fog/vcloud/compute'
        Fog::Vcloud::Compute.new(attributes)
      when :virtualbox
        require 'fog/virtual_box/compute'
        Fog::Compute::VirtualBox.new(attributes)
      when :vmfusion
        require 'fog/vmfusion/compute'
        Fog::Compute::Vmfusion.new(attributes)
      when :voxel
        require 'fog/voxel/compute'
        Fog::Compute::Voxel.new(attributes)
      when :vsphere
        require 'fog/vsphere/compute'
        Fog::Compute::Vsphere.new(attributes)
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
