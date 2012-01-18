require 'fog/ecloud/models/compute/ip'

module Fog
  module Compute
    class Ecloud
      class Ips < Fog::Ecloud::Collection

        model Fog::Compute::Ecloud::Ip

        undef_method :create

        attribute :href

        def all
          check_href!( :messages => "Ips href of a Network you want to enumerate" )
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
