module Fog
  module Storage
    class IBM
      class Real

        # Returns the list of storage volumes
        #
        # ==== Parameters
        # No parameters
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'volumes'<~Array>: list of images
        #       * 'name'<~String>: Name of image
        #       * 'format'<~String>: filesystem volume is formatted with
        #       * 'location'<~String>: datacenter location string
        #       * 'createdTime'<~Integer>: creation time in Epoch int
        #       * 'size'<~String>: size in GB's (as a string)
        #       * 'productCodes'<~Array>: unsure..
        #       * 'offeringId'<~String>:
        #       * 'id'<~String>: volume id
        #       * 'owner'<~String>: owner's email address
        #       * 'state'<~Integer>: known so far: 4 provisioned, unattached; 5 provisioned, attached
        def list_volumes
          request(
            :method   => 'GET',
            :expects  => 200,
            :path     => '/storage'
          )
        end

      end

      class Mock

        def list_volumes
          response = Excon::Response.new
          response.status = 200
          response.body = { 'volumes' => format_list_volumes_response }
          response
        end

      end
    end
  end
end
