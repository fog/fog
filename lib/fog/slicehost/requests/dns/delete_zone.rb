module Fog
  module DNS
    class Slicehost
      class Real

        # Delete a zone from Slicehost's DNS
        # ==== Parameters
        # * zone_id<~Integer> - Id of zone to delete
        #
        # ==== Returns
        # * response<~Excon::Response>: - HTTP status code will be result
        def delete_zone(zone_id)
          request(
            :expects  => 200,
            :method   => 'DELETE',
            :path     => "zones/#{zone_id}.xml"
          )
        end

      end
    end
  end
end
