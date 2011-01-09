module Fog
  module Parsers
    module TerremarkEcloud
      module Compute

        class InstantiateVmTemplate < Fog::Parsers::Base

          def start_element(name, attrs = [])
            case name
            when 'VApp'
              @response['name']   = attr_value('name', attrs)
              @response['uri']    = attr_value('href', attrs)
              @response['status'] = 'deploying'
            end

            super
          end

        end
      end
    end
  end
end
