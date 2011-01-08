module Fog
  module Parsers
    module AWS
      module Compute

        class DescribeImages < Fog::Parsers::Base

          def reset
            @block_device_mapping = {}
            @image = { 'blockDeviceMapping' => [], 'productCodes' => [], 'tagSet' => {} }
            @response = { 'imagesSet' => [] }
            @tag = {}
          end

          def start_element(name, attrs = [])
            super
            case name
            when 'blockDeviceMapping'
              @in_block_device_mapping = true
            when 'tagSet'
              @in_tag_set = true
            end
          end

          def end_element(name)
            if @in_tag_set
              case name
                when 'item'
                  @image['tagSet'][@tag['key']] = @tag['value']
                  @tag = {}
                when 'key', 'value'
                  @tag[name] = @value
                when 'tagSet'
                  @in_tag_set = false
              end
            elsif @in_block_device_mapping
              case name
                when 'blockDeviceMapping'
                  @in_block_device_mapping = false
                when 'deviceName', 'virtualName', 'snapshotId', 'deleteOnTermination'
                  @block_device_mapping[name] = @value
                when 'volumeSize'
                  @block_device_mapping[name] = @value.to_i
                when 'item'
                  @image['blockDeviceMapping'] << @block_device_mapping
                  @block_device_mapping = {}
              end
            else
              case name
              when 'architecture', 'description', 'imageId', 'imageLocation', 'imageOwnerId', 'imageState', 'imageType', 'kernelId', 'name', 'platform', 'ramdiskId', 'rootDeviceType','rootDeviceName','virtualizationType'
                @image[name] = @value
              when 'isPublic'
                if @value == 'true'
                  @image[name] = true
                else
                  @image[name] = false
                end
              when 'item'
                @response['imagesSet'] << @image
                @image = { 'blockDeviceMapping' => [], 'productCodes' => [], 'tagSet' => {} }
              when 'productCode'
                @image['productCodes'] << @value
              when 'requestId'
                @response[name] = @value
              end
            end
          end
        end
      end
    end
  end
end
