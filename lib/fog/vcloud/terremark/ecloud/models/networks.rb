module Fog
  module Vcloud
    module Terremark
      module Ecloud

        module Mock
          def networks(options = {})
            @networks ||= Fog::Vcloud::Terremark::Ecloud::Networks.new(options.merge(:connection => self))
          end
        end

        module Real
          def networks(options = {})
            @networks ||= Fog::Vcloud::Terremark::Ecloud::Networks.new(options.merge(:connection => self))
          end
        end

        class Networks < Fog::Vcloud::Collection

          undef_method :create

          model Fog::Vcloud::Terremark::Ecloud::Network

          get_request :get_network
          vcloud_type "application/vnd.vmware.vcloud.network+xml"
          all_request lambda { |networks| networks.connection.get_vdc(networks.href).body.networks }

          #def all
          #  pp connection.get_vdc(href).body.networks
          #  load(connection.get_vdc(href).body.networks.map { |network| { } } )
          #end

        end
      end
    end
  end
end

