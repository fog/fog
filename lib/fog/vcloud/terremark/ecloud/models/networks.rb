module Fog
  module Vcloud
    module Terremark
      module Ecloud

        module Real
          def networks(options = {})
            @networks ||= Fog::Vcloud::Terremark::Ecloud::Networks.new(options.merge(:connection => self))
          end
        end

        class Networks < Fog::Vcloud::Collection

          undef_method :create

          model Fog::Vcloud::Terremark::Ecloud::Network

          attribute :href

          def all
            if data = connection.get_vdc(href).body[:AvailableNetworks][:Network]
              load(data)
            end
          end

          def get(uri)
            if data = connection.get_network(uri)
              new(data.body)
            end
            rescue Fog::Errors::NotFound
            nil
          end

        end
      end
    end
  end
end

