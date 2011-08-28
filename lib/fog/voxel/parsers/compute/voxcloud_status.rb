module Fog
  module Parsers
    module Compute
      module Voxel
        class VoxcloudStatus < Fog::Parsers::Base
          def reset
            @response = { 'devices' => [] }
            @device = {}
          end

          def start_element(name, attrs = [])
            super

            case name
            when 'rsp'
              @response['stat'] = attr_value('stat', attrs)
            when 'err'
              @response['err'] = {
                'code'  => attr_value('code', attrs),
                'msg'   => attr_value('msg', attrs)
              }
            when 'device'
              @device = {}
            end
          end

          def end_element(name)
            case name
            when 'device'
              @response['devices'] << @device
              @device = {}
            when 'id', 'status'
              @device[name] = value
            when 'last_update'
              @device[name] = Time.at(value.to_i)
            end
          end
        end
      end
    end
  end
end
