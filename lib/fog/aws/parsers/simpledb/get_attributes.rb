module Fog
  module Parsers
    module AWS
      module SimpleDB

        class GetAttributes < Fog::Parsers::AWS::SimpleDB::Basic

          def reset
            @attribute = nil
            @response = { :attributes => {} }
          end

          def end_element(name)
            case name
            when 'BoxUsage'   then response[:box_usage] = @value.to_f
            when 'Name'       then @attribute = @value
            when 'RequestId'  then response[:request_id] = @value
            when 'Value'      then (response[:attributes][@attribute] ||= []) << sdb_decode(@value)
            end
          end

        end

      end
    end
  end
end
