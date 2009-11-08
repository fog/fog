unless Fog.mocking?

  module Fog
    module AWS
      class EC2

        # Describe all or specified key pairs
        #
        # ==== Parameters
        # * key_name<~Array>:: List of key names to describe, defaults to all
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'keySet'<~Array>:
        #       * 'keyName'<~String> - Name of key
        #       * 'keyFingerprint'<~String> - Fingerprint of key
        def describe_key_pairs(key_name = [])
          params = indexed_params('KeyName', key_name)
          request({
            'Action' => 'DescribeKeyPairs'
          }.merge!(params), Fog::Parsers::AWS::EC2::DescribeKeyPairs.new)
        end

      end
    end
  end

else

  module Fog
    module AWS
      class EC2

        def describe_key_pairs(key_name = [])
          response = Fog::Response.new
          key_name = [*key_name]
          if key_name != []
            key_set = Fog::AWS::EC2.data[:key_pairs].reject {|key, value| !key_name.include?(key)}.values
          else
            key_set = Fog::AWS::EC2.data[:key_pairs].values
          end
          if key_name.length == 0 || key_name.length == key_set.length
            response.status = 200
            response.body = {
              'requestId' => Fog::AWS::Mock.request_id,
              'keySet'    => key_set.map do |key|
                key.reject {|key,value| !['keyFingerprint', 'keyName'].include?(key)}
              end
            }
          else
            response.status = 400
            raise(Excon::Errors.status_error(200, 400, response))
          end
          response
        end

      end
    end
  end

end
