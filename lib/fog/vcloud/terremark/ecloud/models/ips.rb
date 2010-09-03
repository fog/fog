module Fog
  class Vcloud
    module Terremark
      module Ecloud

        class Ips < Fog::Vcloud::Collection

          model Fog::Vcloud::Terremark::Ecloud::Ip

          undef_method :create

          attribute :href

          def all
            if data = connection.get_network_ips(href).body[:IpAddress]
              load(data)
            end
          end

          def get(uri)
            if data = connection.get_network_ip(uri).body
              new(data)
            end
          rescue Fog::Errors::NotFound
            nil
          end

        end
      end
    end
  end
end
