module Fog
  module Compute
    class IBM
      class Real

        # Returns details of image specified by id
        #
        # ==== Parameters
        # 'image_id'<~String>: id of desired image
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'name'<~String>: image name
        #     * 'location'<~String>: instance location id
        #     * 'createdTime'<~Integer>: time created in epoch time
        #     * 'supportedInstanceTypes'<~Array>: list of prices per image
        #       * 'pricePerQuantity'<~Integer>:
        #       * 'effectiveDate'<~Fixnum>:
        #       * 'rate'<~Float>: price per unit
        #       * 'countryCode'<~String>:
        #       * 'unitOfMeasure'<~String>: unit of measurement
        #       * 'currencyCode'<~String>: currency billed in
        #     * 'productCodes'<~Array>:
        #     * 'id'<~String>:
        #     * 'documentation'<~String>: link to documentation for image
        #     * 'manifest'<~String>: link to xml manifest file
        #     * 'description'<~String>: text description of image
        #     * 'visibility'<~String>: status of visibilty of image. known values so far are "PUBLIC" and "PRIVATE"
        #     * 'platform'<~String>: operating system
        #     * 'architecture'<~String>: architecture supported by image
        #     * 'documentation'<~String>: link to documentation for image
        #     * 'owner'<~String>: owner of image
        #     * 'state'<~Integer>: state of availability of image
        def get_image(image_id)
          request(
            :method   => 'GET',
            :expects  => 200,
            :path     => "/offerings/image/#{image_id}"
          )
        end

      end

      class Mock

        def get_image(image_id)
          response = Excon::Response.new
          if image_exists? image_id
            response.status = 200
            response.body = self.data[:images][image_id]
          else
            response.status = 404
          end
          response
        end

        private

        def image_exists?(image_id)
          self.data[:images].key? image_id
        end

      end
    end
  end
end
