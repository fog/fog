require 'fog/ecloud/models/compute/ip_address'

module Fog
  module Compute
    class Ecloud
      class IpAddresses < Fog::Ecloud::Collection

        identity :href

        model Fog::Compute::Ecloud::IpAddress

        def all
          data = connection.get_ip_addresses(href).body[:IpAddresses][:IpAddress]
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
