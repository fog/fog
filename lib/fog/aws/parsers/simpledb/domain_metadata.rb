module Fog
  module Parsers
    module AWS
      module SimpleDB

        class DomainMetadata < Fog::Parsers::AWS::SimpleDB::Basic

          def reset
            @response = {}
          end

          def end_element(name)
            case name
            when 'AttributeNameCount'       then response[:attribute_name_count] = @value.to_i
            when 'AttributeNamesSizeBytes'  then response[:attribute_names_size_bytes] = @value.to_i
            when 'AttributeValueCount'      then response[:attribute_value_count] = @value.to_i
            when 'AttributeValuesSizeBytes' then response[:attribute_values_size_bytes] = @value.to_i
            when 'BoxUsage'                 then response[:box_usage] = @value.to_f
            when 'ItemCount'                then response[:item_count] = @value.to_i
            when 'ItemNamesSizeBytes'       then response[:item_names_size_bytes] = @value.to_i
            when 'RequestId'                then response[:request_id] = @value
            when 'Timestamp'                then response[:timestamp] = Time.at(@value.to_i)
            end
          end

        end
        
      end
    end
  end
end