module Fog
  module AWS
    class EC2

      # Describe all or specified key pairs
      #
      # ==== Parameters
      # * key_name<~Array>:: List of key names to describe, defaults to all
      #
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * :request_id<~String> - Id of request
      #     * :key_set<~Array>:
      #       * :key_name<~String> - Name of key
      #       * :key_fingerprint<~String> - Fingerprint of key
      def describe_key_pairs(key_name = [])
        params = indexed_params('KeyName', key_name)
        request({
          'Action' => 'DescribeKeyPairs',
        }.merge!(params), Fog::Parsers::AWS::EC2::DescribeKeyPairs.new)
      end

    end
  end
end
