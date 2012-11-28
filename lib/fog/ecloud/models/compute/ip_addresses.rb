require 'fog/ecloud/models/compute/ip_address'

module Fog
  module Compute
    class Ecloud
      class IpAddresses < Fog::Ecloud::Collection

        identity :href

        model Fog::Compute::Ecloud::IpAddress

        def all
          data = connection.get_network(href).body
          data = if data[:IpAddresses]
                   data[:IpAddresses][:IpAddress]
                 else
                   data
                 end
          data = data.nil? ? [] : data
          load(data)
        end

        def get(uri)
          if data = connection.get_ip_address(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
