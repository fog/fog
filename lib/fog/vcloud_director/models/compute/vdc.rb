require 'fog/core/model'

module Fog
  module Compute
    class VcloudDirector
      class Vdc < Model
        identity  :id

        attribute :name
        attribute :type
        attribute :href
        attribute :description, :aliases => :Description
        attribute :available_networks, :aliases => :AvailableNetworks, :squash => :Network
        attribute :compute_capacity, :aliases => :ComputeCapacity
        attribute :storage_capacity , :aliases => :StorageCapacity
        attribute :allocation_model, :aliases => :AllocationModel
        attribute :capabilities, :aliases => :Capabilities, :squash => :SupportedHardwareVersions
        attribute :nic_quota, :aliases => :NicQuota, :type => :integer
        attribute :network_quota ,:aliases => :NetworkQuota, :type => :integer
        attribute :vm_quota ,:aliases => :VmQuota, :type => :integer
        attribute :is_enabled ,:aliases => :IsEnabled, :type => :boolean

        def medias
          requires :id
          service.medias(:vdc => self)
        end

        def vapps
          requires :id
          service.vapps(:vdc => self)
        end
        
        def networks
          requires :available_networks
          service.networks(:vdc => self)
        end
      end
    end
  end
end
