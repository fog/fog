module Fog
  module Compute

    def self.[](provider)
      self.new(:provider => provider)
    end

    def self.new(attributes)
      attributes = attributes.dup # prevent delete from having side effects
      provider = attributes.delete(:provider).to_s.downcase.to_sym

      case provider
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
      when :hp
        require 'fog/hp/compute'
        Fog::Compute::HP.new(attributes)
      when :ibm
        require 'fog/ibm/compute'
        Fog::Compute::IBM.new(attributes)
      when :joyent
        require 'fog/joyent/compute'
        Fog::Compute::Joyent.new(attributes)
      when :libvirt
        require 'fog/libvirt/compute'
        Fog::Compute::Libvirt.new(attributes)
      when :linode
        require 'fog/linode/compute'
        Fog::Compute::Linode.new(attributes)
      when :new_servers
        require 'fog/bare_metal_cloud/compute'
        warn "[DEPRECATION] `new_servers` is deprecated. Please use `bare_metal_cloud` instead."
        Fog::Compute::BareMetalCloud.new(attributes)
      when :baremetalcloud
        require 'fog/bare_metal_cloud/compute'
        Fog::Compute::BareMetalCloud.new(attributes)
      when :ninefold
        require 'fog/ninefold/compute'
        Fog::Compute::Ninefold.new(attributes)
      when :openstack
        require 'fog/openstack/compute'
        Fog::Compute::OpenStack.new(attributes)
      when :ovirt
        require 'fog/ovirt/compute'
        Fog::Compute::Ovirt.new(attributes)
      when :rackspace
        version = attributes.delete(:version) 
        version = version.to_s.downcase.to_sym unless version.nil?
        if version == :v2
          require 'fog/rackspace/compute_v2'
          Fog::Compute::RackspaceV2.new(attributes)
        else
          require 'fog/rackspace/compute'
          Fog::Compute::Rackspace.new(attributes)
        end
      when :serverlove
        require 'fog/serverlove/compute'
        Fog::Compute::Serverlove.new(attributes)
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
      when :xenserver
        require 'fog/xenserver/compute'
        Fog::Compute::XenServer.new(attributes)
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
