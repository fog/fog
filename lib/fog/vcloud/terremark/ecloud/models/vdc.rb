module Fog
  module Vcloud
    module Terremark
      module Ecloud
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

          def public_ips
            load_unless_loaded!
            @public_ips ||= Fog::Vcloud::Terremark::Ecloud::PublicIps.new( :connection => connection,
                                                                           :href => other_links.detect { |link| link[:type] == "application/vnd.tmrk.ecloud.publicIpsList+xml" }[:href] )
          end

          def internet_services
            @internet_services ||= Fog::Vcloud::Terremark::Ecloud::InternetServices.
              new( :connection => connection,
                   :href => href.to_s.gsub('vdc','extensions/vdc') + "/internetServices" )
          end

          def networks
            @networks ||= Fog::Vcloud::Terremark::Ecloud::Networks.
              new( :connection => connection,
                   :href => href )
          end

          def servers
            @servers ||= Fog::Vcloud::Terremark::Ecloud::Servers.
              new( :connection => connection,
                   :href => href )
          end

          def tasks
            @tasks ||= Fog::Vcloud::Terremark::Ecloud::Tasks.
              new( :connection => connection,
                   :href => href + "/tasksList" )
          end

          def catalog
            @catalog ||= Fog::Vcloud::Terremark::Ecloud::Catalog.
              new( :connection => connection,
                   :href => href + "/catalog" )
          end

        end
      end
    end
  end
end
