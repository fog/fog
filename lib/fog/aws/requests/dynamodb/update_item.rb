module Fog
  module AWS
    class DynamoDB
      class Real

        # Update DynamoDB item
        #
        # ==== Parameters
        # * 'table_name'<~String> - name of table for item
        # * 'key'<~Hash>:
        #   * 'HashKeyElement'<~Hash>: info for primary key
        #     * 'AttributeName'<~String> - name of attribute
        #     * 'AttributeType'<~String> - type of attribute
        #   * 'RangeKeyElement'<~Hash>: optional, info for range key
        #     * 'AttributeName'<~String> - name of attribute
        #     * 'AttributeType'<~String> - type of attribute
        # * 'attribute_updates'<~Hash>:
        #   * 'AttributeName'<~String> - Attribute to update
        #     * 'Value'<~Hash> - formated as {type => value}
        #     * 'Action'<~String> - action to take if expects matches, in %w{ADD DELETE PUT}, defaults to PUT
        # * 'options'<~Hash>:
        #   * 'Expected'<~Hash>: data to check against
        #     * 'AttributeName'<~String> - name of attribute
        #     * 'Value'<~Hash> - a value to check for the value of
        #     or
        #     * 'Exists'<~Boolean> - set as false to only allow update if attribute doesn't exist
        #   * 'ReturnValues'<~String> - data to return in %w{ALL_NEW ALL_OLD NONE UPDATED_NEW UPDATED_OLD}, defaults to NONE
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     varies based on ReturnValues param, see: http://docs.amazonwebservices.com/amazondynamodb/latest/developerguide/API_UpdateItem.html
        def update_item(table_name, key, attribute_updates, options = {})
          body = {
            'AttributeUpdates'  => attribute_updates,
            'Key'               => key,
            'TableName'         => table_name
          }.merge(options)

          request(
            :body     => MultiJson.encode(body),
            :headers  => {'x-amz-target' => 'DynamoDB_20111205.UpdateItem'}
          )
        end

      end
    end
  end
end
