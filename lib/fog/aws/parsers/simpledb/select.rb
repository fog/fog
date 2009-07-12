module Fog
  module Parsers
    module AWS
      module SimpleDB

        class Select < Fog::Parsers::AWS::SimpleDB::Basic

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
