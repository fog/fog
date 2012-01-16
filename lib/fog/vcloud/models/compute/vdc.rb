module Fog
  module Vcloud
    class Compute
      class Vdc < Fog::Vcloud::Model

        identity :href

        ignore_attributes :xmlns, :xmlns_xsi, :xmlns_xsd

        attribute :name
        attribute :type
        attribute :description, :aliases => :Description
        attribute :network_quota, :aliases => :NetworkQuota, :type => :integer
        attribute :nic_quota, :aliases => :NicQuota, :type => :integer
        attribute :vm_quota, :aliases => :VmQuota, :type => :integer
        attribute :is_enabled, :aliases => :IsEnabled, :type => :boolean
        attribute :compute_capacity, :aliases => :ComputeCapacity
        attribute :storage_capacity, :aliases => :StorageCapacity
        attribute :available_networks, :aliases => :AvailableNetworks, :squash => :Network

        attribute :other_links, :aliases => :Link

        attribute :resource_entities, :aliases => :ResourceEntities, :squash => :ResourceEntity

        def networks
          @networks ||= Fog::Vcloud::Compute::Networks.
            new( :connection => connection,
                 :href => href )
        end

        def vapps
          @vapps ||= Fog::Vcloud::Compute::Vapps.
            new( :connection => connection,
                 :href => href
            )
        end

      end
    end
  end
end
