unless Fog.mocking?

  module Fog
    module AWS
      class EC2

        # Describe all or specified images.
        #
        # ==== Params
        # * options<~Hash> - Optional params
        #   * 'ExecutableBy'<~String> - Only return images that the executable_by
        #     user has explicit permission to launch
        #   * 'ImageId'<~Array> - Ids of images to describe
        #   * 'Owner'<~String> - Only return images belonging to owner.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'imagesSet'<~Array>:
        #       * 'architecture'<~String> - Architecture of the image
        #       * 'imageId'<~String> - Id of the image
        #       * 'imageLocation'<~String> - Location of the image
        #       * 'imageOwnerId'<~String> - Id of the owner of the image
        #       * 'imageState'<~String> - State of the image
        #       * 'imageType'<~String> - Type of the image
        #       * 'isPublic'<~Boolean> - Whether or not the image is public
        #       * 'kernelId'<~String> - Kernel id associated with image, if any
        #       * 'platform'<~String> - Operating platform of the image
        #       * 'productCodes'<~Array> - Product codes for the image
        #       * 'ramdiskId'<~String> - Ramdisk id associated with image, if any
        def describe_images(options = {})
          if image_id = options.delete('ImageId')
            options.merge!(AWS.indexed_param('ImageId', image_id))
          end
          request({
            'Action' => 'DescribeImages'
          }.merge!(options), Fog::Parsers::AWS::EC2::DescribeImages.new)
        end

      end
    end
  end

else

  module Fog
    module AWS
      class EC2

        def describe_images(options = {})
          response = Excon::Response.new
          images = []

          (rand(101 + 100)).times do
            images << Fog::AWS::Mock.image
          end

          response.status = 200
          response.body = {
            'requestId' => Fog::AWS::Mock.request_id,
            'imagesSet' => images
          }
          response
        end

      end
    end
  end

end
