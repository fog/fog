module Fog
  module AWS
    class EC2

      # Describe all or specified images.
      #
      # ==== Params
      # * options<~Hash> - Optional params
      #   * :executable_by<~String> - Only return images that the executable_by
      #     user has explicit permission to launch
      #   * :image_id<~Array> - Ids of images to describe
      #   * :owner<~String> - Only return images belonging to owner.
      #
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * :request_id<~String> - Id of request
      #     * :image_set<~Array>:
      #       * :architecture<~String> - Architecture of the image
      #       * :image_id<~String> - Id of the image
      #       * :image_location<~String> - Location of the image
      #       * :image_owner_id<~String> - Id of the owner of the image
      #       * :image_state<~String> - State of the image
      #       * :image_type<~String> - Type of the image
      #       * :is_public<~Boolean> - Whether or not the image is public
      #       * :kernel_id<~String> - Kernel id associated with image, if any
      #       * :platform<~String> - Operating platform of the image
      #       * :productCodes<~Array> - Product codes for the image
      #       * :ramdisk_id<~String> - Ramdisk id associated with image, if any
      def describe_images(options = {})
        params = {}
        if options[:image_id]
          params = indexed_params('ImageId', options[:image_id])
        end
        request({
          'Action' => 'DescribeImages',
          'ExecutableBy' => options[:executable_by],
          'Owner' => options[:owner]
        }.merge!(params), Fog::Parsers::AWS::EC2::DescribeImages.new)
      end

    end
  end
end
