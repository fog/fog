module Fog
  module AWS
    class Compute
      class Real

        require 'fog/compute/parsers/aws/describe_images'

        # Describe all or specified images.
        #
        # ==== Params
        # * filters<~Hash> - List of filters to limit results with
        #   * filters and/or the following
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
        #       * 'blockDeviceMapping'<~Array> - An array of mapped block devices
        #       * 'description'<~String> - Description of image
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
        #       * 'rootDeviceName'<~String> - Root device name, e.g. /dev/sda1
        #       * 'rootDeviceType'<~String> - Root device type, ebs or instance-store
        #       * 'virtualizationType'<~String> - Type of virtualization
        def describe_images(filters = {})
          options = {}
          for key in ['ExecutableBy', 'ImageId', 'Owner']
            if filters.is_a?(Hash) && filters.key?(key)
              options[key] = filters.delete(key)
            end
          end
          params = AWS.indexed_filters(filters).merge!(options)
          request({
            'Action'    => 'DescribeImages',
            :idempotent => true,
            :parser     => Fog::Parsers::AWS::Compute::DescribeImages.new
          }.merge!(params))
        end

      end

      class Mock

        def describe_images(filters = {})
          unless filters.is_a?(Hash)
            Formatador.display_line("[yellow][WARN] describe_images with #{filters.class} param is deprecated, use describe_snapshots('snapshot-id' => []) instead[/] [light_black](#{caller.first})[/]")
            filters = {'snapshot-id' => [*filters]}
          end
          
          if filters.keys.any? {|key| key =~ /^block-device/}
            Formatador.display_line("[yellow][WARN] describe_images block-device-mapping filters are not yet mocked[/] [light_black](#{caller.first})[/]")
            Fog::Mock.not_implemented
          end
          
          if filters.keys.any? {|key| key =~ /^tag/}
            Formatador.display_line("[yellow][WARN] describe_images tag filters are not yet mocked[/] [light_black](#{caller.first})[/]")
            Fog::Mock.not_implemented
          end
          
          response = Excon::Response.new
          
          aliases = {
            'architecture'        => 'architecture',
            'description'         => 'description',
            'hypervisor'          => 'hypervisor',
            'image-id'            => 'imageId',
            'image-type'          => 'imageType',
            'is-public'           => 'isPublic',
            'kernel-id'           => 'kernelId',
            'manifest-location'   => 'manifestLocation',
            'name'                => 'name',            
            'owner-id'            => 'imageOwnerId',
            'ramdisk-id'          => 'ramdiskId',
            'root-device-name'    => 'rootDeviceName',
            'root-device-type'    => 'rootDeviceType',
            'state'               => 'imageState',
            'virtualization-type' => 'virtualizationType'
          }
          
          image_set = @data[:images].values
          
          for filter_key, filter_value in filters
            aliased_key = aliases[filter_key]
            image_set = image_set.reject{|image| ![*filter_value].include?(image[aliased_key])}
          end

          response.status = 200
          response.body = {
            'requestId' => Fog::AWS::Mock.request_id,
            'imagesSet' => image_set
          }
          response
        end

      end
    end
  end
end
