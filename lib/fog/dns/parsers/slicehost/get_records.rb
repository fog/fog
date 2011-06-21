module Fog
  module Parsers
    module DNS
      module Slicehost

        class GetRecords < Fog::Parsers::Base

          def reset
            @record = {}
            @response = { 'records' => [] }
          end

          def end_element(name)
            case name
            when 'zone-id', 'ttl'
              @record[name] = value.to_i
            when 'record-type', 'name', 'data', 'active', 'aux'
              @record[name] = value
            when 'record'
              @response['records'] << @record
              @record = {}
            end
          end

        end

      end
    end
  end
end
