module Fog
  module AWS
    class EC2

      # Create a new key pair
      #
      # ==== Parameters
      # * key_name<~String> - Unique name for key pair.
      #
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * :key_name<~String> - Name of key
      #     * :key_fingerprint<~String> - SHA-1 digest of DER encoded private key
      #     * :key_material<~String> - Unencrypted encoded PEM private key
      #     * :request_id<~String> - Id of request
      def create_key_pair(key_name)
        request({
          'Action' => 'CreateKeyPair',
          'KeyName' => key_name
        }, Fog::Parsers::AWS::EC2::CreateKeyPair.new)
      end

    end
  end
end
