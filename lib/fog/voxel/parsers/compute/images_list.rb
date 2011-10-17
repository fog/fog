module Fog
  module Parsers
    module Compute
      module Voxel

        class ImagesList < Fog::Parsers::Base

          def reset
            @image = {}
            @response = { 'images' => [] }
          end

          def start_element(name, attrs = [])
            super

            case name
            when 'err'
              @response['err'] = {
                'code'  => attr_value('code', attrs),
                'msg'   => attr_value('msg', attrs)
              }
            when 'size'
              @image['filesystem']['units'] = attr_value('units', attrs)
            when 'image'
              @image = {
                'id' => attr_value('id', attrs).to_i,
                'summary' => attr_value('summary', attrs)
              }
            when 'filesystem', 'operating_system'
              @image[name] = {}
            when 'rsp'
              @response['stat'] = attr_value('stat', attrs)
            end
          end

          def end_element(name)
            case name
            when 'architecture'
              @image['operating_system'][name] = value.to_i
            when 'admin_username', 'family', 'product_family', 'product_version', 'version'
              @image['operating_system'][name] = value
            when 'description'
              @image[name] = value
            when 'image'
              @response['images'] << @image
              @image = {}
            when 'size'
              @image['filesystem'][name] = value.to_i
            when 'type'
              @image['filesystem'][name] = value
            end
          end

        end

      end
    end
  end
end