module Fog
  module AWS
    class DynamoDB
      class Real

        # Delete DynamoDB table
        #
        # ==== Parameters
        # * 'table_name'<~String> - name of table to delete
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'TableDescription'<~Hash>
        #       * 'CreationDateTime'<~Float> - Unix epoch time of table creation
        #       * 'KeySchema'<~Hash> - schema for table
        #         * 'HashKeyElement'<~Hash>: info for primary key
        #           * 'AttributeName'<~String> - name of attribute
        #           * 'AttributeType'<~String> - type of attribute, in %w{N S} for number or string
        #         * 'RangeKeyElement'<~Hash>: optional, info for range key
        #           * 'AttributeName'<~String> - name of attribute
        #           * 'AttributeType'<~String> - type of attribute, in %w{N S} for number or string
        #       * 'ProvisionedThroughput'<~Hash>:
        #         * 'ReadCapacityUnits'<~Integer> - read capacity for table, in 5..10000
        #         * 'WriteCapacityUnits'<~Integer> - write capacity for table, in 5..10000
        #       * 'TableName'<~String> - name of table
        #       * 'TableStatus'<~String> - status of table
        def delete_table(table_name)
          body = {
            'TableName' => table_name
          }

          request(
            :body       => MultiJson.encode(body),
            :headers    => {'x-amz-target' => 'DynamoDB_20111205.DeleteTable'},
            :idempotent => true
          )
        end

      end
    end
  end
end
