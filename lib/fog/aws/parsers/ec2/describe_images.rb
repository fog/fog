module Fog
  module Parsers
    module AWS
      module EC2

        class DescribeImages < Fog::Parsers::Base

          def reset
            @image = { :product_codes => [] }
            @response = { :image_set => [] }
          end

          def start_element(name, attrs = [])
            if name == 'productCodes'
              @in_product_codes = true
            end
            @value = ''
          end
          
          def end_element(name)
            case name
            when 'architecture'
              @image[:architecture] = @value
            when 'imageId'
              @image[:image_id] = @value
            when 'imageLocation'
              @image[:image_location] = @value
            when 'imageOwnerId'
              @image[:image_owner_id] = @value
            when 'imageState'
              @image[:image_state] = @value
            when 'imageType'
              @image[:image_type] = @value
            when 'isPublic'
              if @value == 'true'
                @image[:is_public] = true
              else
                @image[:is_public] = false
              end
            when 'item'
              unless @in_product_codes
                @response[:image_set] << @image
                @image = { :product_codes => [] }
              end
            when 'kernelId'
              @image[:kernel_id] = @value
            when 'platform'
              @image[:platform] = @value
            when 'productCode'
              @image[:product_codes] << @value
            when 'productCodes'
              @in_product_codes = false
            when 'ramdiskId'
              @image[:ramdisk_id] = @value
            when 'requestId'
              @response[:request_id] = @value
            end
          end

        end

      end
    end
  end
end
