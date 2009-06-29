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
            when 'BoxUsage'   then response[:box_usage] = @value.to_f
            when 'RequestId'  then response[:request_id] = @value
            end
          end

          def sdb_decode(value)
            value.eql?(@nil_string) ? nil : value
          end

        end

        class ListDomainsParser < Fog::Parsers::AWS::SimpleDB::BasicParser

          def reset
            @response = { :domains => [] }
          end

          def end_element(name)
            case(name)
            when 'BoxUsage'   then response[:box_usage] = @value.to_f
            when 'DomainName' then response[:domains] << @value
            when 'NextToken'  then response[:next_token] = @value
            when 'RequestId'  then response[:request_id] = @value
            end
          end

        end

        class DomainMetadataParser < Fog::Parsers::AWS::SimpleDB::BasicParser

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

        class GetAttributesParser < Fog::Parsers::AWS::SimpleDB::BasicParser

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

        class SelectParser < Fog::Parsers::AWS::SimpleDB::BasicParser

          def reset
            @item_name = @attribute_name = nil
            @response = { :items => {} }
          end

          def end_element(name)
            case name
            when 'BoxUsage'   then response[:box_usage] = @value.to_f
            when 'Item'       then @item_name = @attribute_name = nil
            when 'Name'       then @item_name.nil? ? @item_name = @value : @attribute_name = @value
            when 'NextToken'  then response[:next_token] = @value
            when 'RequestId'  then response[:request_id] = @value
            when 'Value'      then ((response[:items][@item_name] ||= {})[@attribute_name] ||= []) << sdb_decode(@value)
            end
          end

        end

      end
    end
  end
end
