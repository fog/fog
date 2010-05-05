module Fog
  module Parsers
    module AWS
      module EC2

        class DescribeImages < Fog::Parsers::Base

          def reset
            @image = { 'productCodes' => [] }
            @response = { 'imagesSet' => [] }
          end

          def start_element(name, attrs = [])
            super
            if name == 'productCodes'
              @in_product_codes = true
            end
          end
          
          def end_element(name)
            case name
            when 'architecture',  'imageId', 'imageLocation', 'imageOwnerId', 'imageState', 'imageType', 'kernelId', 'platform', 'ramdiskId'
              @image[name] = @value
            when 'isPublic'
              if @value == 'true'
                @image[name] = true
              else
                @image[name] = false
              end
            when 'item'
              unless @in_product_codes
                @response['imagesSet'] << @image
                @image = { 'productCodes' => [] }
              end
            when 'productCode'
              @image['productCodes'] << @value
            when 'productCodes'
              @in_product_codes = false
            when 'requestId'
              @response[name] = @value
            end
          end

        end

      end
    end
  end
end
