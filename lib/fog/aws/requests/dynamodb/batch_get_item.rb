module Fog
  module AWS
    class DynamoDB
      class Real

        # Get DynamoDB items
        #
        # ==== Parameters
        # * 'request_items'<~Hash>:
        #   * 'table_name'<~Hash>:
        #     * 'Keys'<~Array>: array of keys
        #       * 'HashKeyElement'<~Hash>: info for primary key
        #         * 'AttributeType'<~String> - type of attribute
        #         * 'AttributeName'<~String> - name of attribute
        #       * 'RangeKeyElement'<~Hash>: optional, info for range key
        #         * 'AttributeType'<~String> - type of attribute
        #         * 'AttributeName'<~String> - name of attribute
        #     * 'AttributesToGet'<~Array> - optional attributes to return, defaults to all
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'Responses'<~Hash>:
        #       * 'table_name'<~Hash>:
        #         * 'Items'<~Array> - Matching items
        #         * 'ConsumedCapacityUnits'<~Float> - Capacity units used in read
        #     * 'UnprocessedKeys':<~Hash> - tables and keys in excess of per request limit, pass this to subsequent batch get for pseudo-pagination
        def batch_get_item(request_items)
          body = {
            'RequestItems' => request_items
          }

          request(
            :body       => MultiJson.encode(body),
            :headers    => {'x-amz-target' => 'DynamoDB_20111205.BatchGetItem'},
            :idempotent => true
          )
        end

      end
    end
  end
end
