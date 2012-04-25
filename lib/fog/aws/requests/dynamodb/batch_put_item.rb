module Fog
  module AWS
    class DynamoDB
      class Real

        #request_items has form:
        #{"table_name"=>
        #  [{"PutRequest"=>
        #    {"Item"=>
        #      {"hash_key"=>{"N"=>"99"},
        #       "range_key"=>{"N"=>"99"},
        #       "attribute"=>{"S"=>"hi"}
        #       }}}, ... ]}
        # For more information:
        # http://docs.amazonwebservices.com/amazondynamodb/latest/developerguide/API_BatchWriteItems.html
        def batch_put_item(request_items)
          body = {
            'RequestItems' => request_items
          }

          request(
            :body       => Fog::JSON.encode(body),
            :headers    => {'x-amz-target' => 'DynamoDB_20111205.BatchWriteItem'}
          )
        end

      end
    end
  end
end
