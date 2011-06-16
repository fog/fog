module Fog
  module DNS
    class Bluebox
      class Real

        # Delete a record from the specified DNS zone
        # ==== Parameters
        # * record_id<~Integer> - Id of DNS record to delete
        #
        # ==== Returns
        # * response<~Excon::Response>: - HTTP status code will be result
        def delete_record(zone_id, record_id)
          request(
            :expects  => 200,
            :method   => 'DELETE',
            :path     => "/api/domains/#{zone_id}/records/#{record_id}.xml"
          )
        end

      end

      class Mock

        def delete_record(zone_id, record_id)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
