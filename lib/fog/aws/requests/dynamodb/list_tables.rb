module Fog
  module AWS
    class DynamoDB
      class Real

        # List DynamoDB tables
        #
        # ==== Parameters
        # * 'options'<~Hash> - options, defaults to {}
        #   * 'ExclusiveStartTableName'<~String> - name of table to begin listing with
        #   * 'Limit'<~Integer> - limit number of tables to return
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'LastEvaluatedTableName'<~String> - last table name, for pagination
        #     * 'TableNames'<~Array> - table names
        def list_tables(options = {})
          request(
            :body       => MultiJson.encode(options),
            :headers    => {'x-amz-target' => 'DynamoDB_20111205.ListTables'},
            :idempotent => true
          )
        end

      end
    end
  end
end
