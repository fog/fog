module Fog
  module Compute
    class Slicehost
      class Real

        # Delete a given slice
        # ==== Parameters
        # * slice_id<~Integer> - Id of slice to delete
        #
        # ==== Returns
        # * response<~Excon::Response>: - HTTP status code is the return value
        def delete_slice(slice_id)
          request(
            :expects  => 200,
            :method   => 'DELETE',
            :path     => "slices/#{slice_id}.xml"
          )
        end

      end
    end
  end
end
