module Fog
  module DNS
    class Bluebox
      class Real

        # Delete a zone from DNS
        # ==== Parameters
        # * zone_id<~Integer> - Id of zone to delete
        #
        # ==== Returns
        # * response<~Excon::Response>: - HTTP status code will be result
        def delete_zone(zone_id)
          request(
            :expects  => 200,
            :method   => 'DELETE',
            :path     => "/api/domains/#{zone_id}.xml"
          )
        end

      end

      class Mock

        def delete_zone(zone_id)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
