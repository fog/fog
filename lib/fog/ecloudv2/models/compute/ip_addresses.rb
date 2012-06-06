require 'fog/ecloudv2/models/compute/ip_address'

module Fog
  module Compute
    class Ecloudv2
      class IpAddresses < Fog::Ecloudv2::Collection

        identity :href

        model Fog::Compute::Ecloudv2::IpAddress

        def all
          data = connection.get_ip_addresses(href).body[:IpAddresses][:IpAddress]
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
