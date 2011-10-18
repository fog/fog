module Fog
  module Parsers
    module Compute
      module Voxel

        class Basic < Fog::Parsers::Base

          def reset
            @response = {}
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

        end

      end
    end
  end
end
