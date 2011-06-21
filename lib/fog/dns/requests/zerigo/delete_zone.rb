module Fog
  module DNS
    class Zerigo
      class Real

        # Delete a zone from Zerigo
        #
        # ==== Parameters
        # * zone_id<~Integer> - Id of zone to delete
        # ==== Returns
        # * response<~Excon::Response>:
        #   * 'status'<~Integer> - 200 indicates success
        
        def delete_zone(zone_id)
          request(
            :expects  => 200,
            :method   => 'DELETE',
            :path     => "/api/1.1/zones/#{zone_id}.xml"
          )
        end

      end
    end
  end
end
