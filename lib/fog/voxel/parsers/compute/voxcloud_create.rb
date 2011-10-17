module Fog
  module Parsers
    module Compute
      module Voxel

        class VoxcloudCreate < Fog::Parsers::Base

          def reset
            @response = { 'device' => {} }
          end

          def start_element(name, attrs = [])
            super

            case name
            when 'err'
              @response['err'] = {
                'code'  => attr_value('code', attrs),
                'msg'   => attr_value('msg', attrs)
              }
            when 'rsp'
              @response['stat'] = attr_value('stat', attrs)
            end
          end

          def end_element(name)
            case name
            when 'id'
              @response['device'][name] = value
            when 'last_update'
              @response['device'][name] = Time.at(value.to_i)
            end
          end

        end

      end
    end
  end
end
