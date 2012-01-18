module Fog
  module DNS
    class Slicehost
      class Real

        # Delete a record from the specified DNS zone
        # ==== Parameters
        # * record_id<~Integer> - Id of DNS record to delete
        #
        # ==== Returns
        # * response<~Excon::Response>: - HTTP status code will be result
        def delete_record(record_id)
          request(
            :expects  => 200,
            :method   => 'DELETE',
            :path     => "records/#{record_id}.xml"
          )
        end

      end
    end
  end
end
