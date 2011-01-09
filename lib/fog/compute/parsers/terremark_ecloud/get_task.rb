module Fog
  module Parsers
    module TerremarkEcloud
      module Compute

        class GetTask < Fog::Parsers::Base

          def reset
            @response = { 'owner' => {}, 'result' => {} }
          end

          def start_element(name, attrs = [])
            case name
            when 'Task'
              @response['uri']       = attr_value('href', attrs)
              @response['status']    = attr_value('status', attrs)
              @response['startTime'] = (start_time = attr_value('startTime', attrs) and Time.parse(start_time))
              @response['endTime']   = (end_time   = attr_value('endTime', attrs)   and Time.parse(end_time))
            when 'Owner', 'Result'
              href, type, this_name = %w(href type name).map {|a| attr_value(a, attrs) }
              @response[name.downcase] = {
                'uri' => href,
                'type' => type,
                'name' => this_name
              }
            end

            super
          end

        end
      end
    end
  end
end
