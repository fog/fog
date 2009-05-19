require File.dirname(__FILE__) + '/../../parser'

module Fog
  module Parsers
    module AWS
      module SimpleDB
        class BasicParser < Fog::Parsers::Base

          def initialize(nil_string)
            @nil_string = nil_string
            reset
          end

          def end_element(name)
            case(name)
            when 'BoxUsage'   then result[:box_usage] = @value.to_f
            when 'RequestId'  then result[:request_id] = @value
            end
          end

          def sdb_decode(value)
            value.eql?(@nil_string) ? nil : value
          end

        end

        class ListDomainsParser < Fog::Parsers::AWS::SimpleDB::BasicParser

          def reset
            @result = { :domains => [] }
          end

          def end_element(name)
            case(name)
            when 'BoxUsage'   then result[:box_usage] = @value.to_f
            when 'DomainName' then result[:domains] << @value
            when 'NextToken'  then result[:next_token] = @value
            when 'RequestId'  then result[:request_id] = @value
            end
          end
        
        end

        class DomainMetadataParser < Fog::Parsers::AWS::SimpleDB::BasicParser

          def reset
            @result = {}
          end

          def end_element(name)
            case name
            when 'AttributeNameCount'       then result[:attribute_name_count] = @value.to_i
            when 'AttributeNamesSizeBytes'  then result[:attribute_names_size_bytes] = @value.to_i
            when 'AttributeValueCount'      then result[:attribute_value_count] = @value.to_i
            when 'AttributeValuesSizeBytes' then result[:attribute_values_size_bytes] = @value.to_i
            when 'BoxUsage'                 then result[:box_usage] = @value.to_f
            when 'ItemCount'                then result[:item_count] = @value.to_i
            when 'ItemNamesSizeBytes'       then result[:item_names_size_bytes] = @value.to_i
            when 'RequestId'                then result[:request_id] = @value
            when 'Timestamp'                then result[:timestamp] = @value
            end
          end

        end

        class GetAttributesParser < Fog::Parsers::AWS::SimpleDB::BasicParser

          def reset
            @attribute = nil
            @result = { :attributes => {} }
          end

          def end_element(name)
            case name
            when 'BoxUsage'   then result[:box_usage] = @value.to_f
            when 'Name'       then @attribute = @value
            when 'RequestId'  then result[:request_id] = @value
            when 'Value'      then (result[:attributes][@attribute] ||= []) << sdb_decode(@value)
            end
          end

        end

        class SelectParser < Fog::Parsers::AWS::SimpleDB::BasicParser

          def reset
            @item_name = @attribute_name = nil
            @result = { :items => {} }
          end

          def end_element(name)
            case name
            when 'BoxUsage'   then result[:box_usage] = @value.to_f
            when 'Item'       then @item_name = @attribute_name = nil
            when 'Name'       then @item_name.nil? ? @item_name = @value : @attribute_name = @value
            when 'NextToken'  then result[:next_token] = @value
            when 'RequestId'  then result[:request_id] = @value
            when 'Value'      then ((result[:items][@item_name] ||= {})[@attribute_name] ||= []) << sdb_decode(@value)
            end
          end

        end

      end
    end
  end
end
