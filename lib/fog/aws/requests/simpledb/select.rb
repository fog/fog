unless Fog.mocking?

  module Fog
    module AWS
      class SimpleDB

        # Select item data from SimpleDB
        #
        # ==== Parameters
        # * select_expression<~String> - Expression to query domain with.
        # * next_token<~String> - Offset token to start list, defaults to nil.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'BoxUsage'<~Float>
        #     * 'RequestId'<~String>
        #     * 'Items'<~Hash> - list of attribute name/values for the items formatted as 
        #       { 'item_name' => { 'attribute_name' => ['attribute_value'] }}
        #     * 'NextToken'<~String> - offset to start with if there are are more domains to list
        def select(select_expression, next_token = nil)
          request({
            'Action' => 'Select',
            'NextToken' => next_token,
            'SelectExpression' => select_expression
          }, Fog::Parsers::AWS::SimpleDB::Select.new(@nil_string))
        end

      end
    end
  end

else

  module Fog
    module AWS
      class SimpleDB

        def select(select_expression, next_token = nil)
          raise MockNotImplemented.new("Contributions welcome!")
        end

      end
    end
  end

end
