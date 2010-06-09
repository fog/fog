module Fog
  module Vcloud
    module Terremark
      module Ecloud

        class Ips < Fog::Vcloud::Collection

          model Fog::Vcloud::Terremark::Ecloud::Ip

          undef_method :create

          def all
            load(connection.get_network_ips(href).body.addresses.
                 map { |address| { :name => address.name, :status => address.status, :server => address.server } })
          end

          def get_raw(name)
            raw_results.detect { |address| address.name == name }
          end

          def reload
            super
            @raw_results = nil
          end

          private

          def raw_results
            @raw_results ||= connection.get_network_ips(href).body.addresses
          end

        end
      end
    end
  end
end
