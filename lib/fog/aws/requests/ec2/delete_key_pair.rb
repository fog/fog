unless Fog.mocking?

  module Fog
    module AWS
      class EC2

        # Delete a key pair that you own
        #
        # ==== Parameters
        # * key_name<~String> - Name of the key pair.
        #
        # ==== Returns
        # * response<~Fog::AWS::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> id of request
        #     * 'return'<~Boolean> - success?
        def delete_key_pair(key_name)
          request({
            'Action' => 'DeleteKeyPair',
            'KeyName' => key_name
          }, Fog::Parsers::AWS::EC2::Basic.new)
        end

      end
    end
  end

else

  module Fog
    module AWS
      class EC2

        def delete_key_pair(key_name)
          response = Fog::Response.new
          @data[:key_pairs].delete(key_name)
          response.status = 200
          response.body = {
            'requestId' => Fog::AWS::Mock.request_id,
            'return'    => true
          }
          response
        end

      end
    end
  end

end
