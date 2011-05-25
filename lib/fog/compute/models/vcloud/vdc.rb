module Fog
  module Vcloud
    class Compute
      class Vdc < Fog::Vcloud::Model

        identity :href

        ignore_attributes :xmlns, :xmlns_xsi, :xmlns_xsd

        attribute :name
        attribute :type
        attribute :description, :aliases => :Description
        attribute :other_links, :aliases => :Link
        attribute :compute_capacity, :aliases => :ComputeCapacity
        attribute :storage_capacity, :aliases => :StorageCapacity
        attribute :available_networks, :aliases => :AvailableNetworks, :squash => :Network
        attribute :resource_entities, :aliases => :ResourceEntities, :squash => :ResourceEntity
        attribute :deployed_vm_quota
        attribute :instantiated_vm_quota

        def networks
          @networks ||= Fog::Vcloud::Compute::Networks.
            new( :connection => connection,
                 :href => href )
        end

        def servers
          @servers ||= Fog::Vcloud::Compute::Servers.
            new( :connection => connection,
                 :href => href )
        end

        def tasks
          @tasks ||= Fog::Vcloud::Compute::Tasks.
            new( :connection => connection,
                 :href => href + "/tasksList" )
        end

        private

        def collection_based_on_type(type, klass = nil)
          load_unless_loaded!
          test_links = other_links.kind_of?(Array) ? other_links : [other_links]
          if link = test_links.detect { |link| link[:type] == type }
            case type
            when "application/vnd.vmware.vcloud.catalog+xml"
              Fog::Vcloud::Compute::Catalog
            end.new( :connection => connection, :href => link[:href] )
          else
            [ ]
          end
        end
      end
    end
  end
end
