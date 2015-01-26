module Fog
  module Parsers
    module DNS
      module Bluebox
        class GetRecords < Fog::Parsers::Base
          def reset
            @record = {}
            @response = { 'records' => [] }
          end

          def end_element(name)
            case name
            when 'record'
              @response['records'] << @record
              @record = {}
            else
              @record[name] = value
            end
          end
        end
      end
    end
  end
end
