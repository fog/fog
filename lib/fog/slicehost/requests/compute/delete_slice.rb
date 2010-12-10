module Fog
  module Slicehost
    class Compute
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

      class Mock

        def delete_slice(slice_id)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
