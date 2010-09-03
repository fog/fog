module Fog
  module AWS
    class EC2
      class Real

        require 'fog/aws/parsers/ec2/describe_key_pairs'

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
          params = AWS.indexed_param('KeyName', key_name)
          request({
            'Action'    => 'DescribeKeyPairs',
            :idempotent => true,
            :parser     => Fog::Parsers::AWS::EC2::DescribeKeyPairs.new
          }.merge!(params))
        end

      end

      class Mock

        def describe_key_pairs(key_name = [])
          response = Excon::Response.new
          key_name = [*key_name]
          if key_name != []
            key_set = @data[:key_pairs].reject {|key, value| !key_name.include?(key)}.values
          else
            key_set = @data[:key_pairs].values
          end
          if key_name.length == 0 || key_name.length == key_set.length
            response.status = 200
            response.body = {
              'requestId' => Fog::AWS::Mock.request_id,
              'keySet'    => key_set.map do |key|
                key.reject {|key,value| !['keyFingerprint', 'keyName'].include?(key)}
              end
            }
            response
          else
            raise Fog::AWS::EC2::NotFound.new("The key pair #{key_name.inspect} does not exist")
          end
        end

      end
    end
  end
end
