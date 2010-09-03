module Fog
  class Vcloud
    module Terremark
      module Ecloud

        module Mock
          def public_ips(options = {})
            @public_ips ||= Fog::Vcloud::Terremark::Ecloud::PublicIps.new(options.merge(:connection => self))
          end
        end

        module Real
          def public_ips(options = {})
            @public_ips ||= Fog::Vcloud::Terremark::Ecloud::PublicIps.new(options.merge(:connection => self))
          end
        end

        class PublicIps < Fog::Vcloud::Collection

          undef_method :create

          attribute :href, :aliases => :Href

          model Fog::Vcloud::Terremark::Ecloud::PublicIp

          #get_request :get_public_ip
          #vcloud_type "application/vnd.tmrk.ecloud.publicIp+xml"
          #all_request lambda { |public_ips| public_ips.connection.get_public_ips(public_ips.href) }

          def all
            if data = connection.get_public_ips(href).body[:PublicIPAddress]
              load(data)
            end
          end

          def get(uri)
            if data = connection.get_public_ip(uri)
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
