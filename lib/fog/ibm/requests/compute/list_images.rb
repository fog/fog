module Fog
  module Compute
    class IBM
      class Real

        # Returns the list of Images available to be provisioned on the IBM DeveloperCloud.
        #
        # ==== Parameters
        # No parameters
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'images'<~Array>: list of images
        #       * 'name'<~String>: image name
        #       * 'location'<~String>: instance location id
        #       * 'createdTime'<~Integer>: time created in epoch time
        #       * 'supportedInstanceTypes'<~Array>: list of prices per image
        #         * 'pricePerQuantity'<~Integer>:
        #         * 'effectiveDate'<~Fixnum>:
        #         * 'rate'<~Float>: price per unit
        #         * 'countryCode'<~String>:
        #         * 'unitOfMeasure'<~String>: unit of measurement
        #         * 'currencyCode'<~String>: currency billed in
        #       * 'productCodes'<~Array>:
        #       * 'id'<~String>:
        #       * 'documentation'<~String>: link to documentation for image
        #       * 'manifest'<~String>: link to xml manifest file
        #       * 'description'<~String>: text description of image
        #       * 'visibility'<~String>: status of visibilty of image. known values so far are "PUBLIC" and "PRIVATE"
        #       * 'platform'<~String>: operating system
        #       * 'architecture'<~String>: architecture supported by image
        #       * 'documentation'<~String>: link to documentation for image
        #       * 'owner'<~String>: owner of image
        #       * 'state'<~Integer>: state of availability of image
        def list_images
          request(
            :method   => 'GET',
            :expects  => 200,
            :path     => '/offerings/image'
          )
        end

      end

      class Mock

        def list_images
          response = Excon::Response.new
          response.status = 200
          response.body = {'images' => self.data[:images].values}
          response
        end

      end
    end
  end
end
