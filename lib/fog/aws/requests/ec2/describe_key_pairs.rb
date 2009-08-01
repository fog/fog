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
