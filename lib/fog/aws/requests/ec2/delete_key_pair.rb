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
      #     * :return<~Boolean> - success?
      def delete_key_pair(key_name)
        request({
          'Action' => 'DeleteKeyPair',
          'KeyName' => key_name
        }, Fog::Parsers::AWS::EC2::Basic.new)
      end

    end
  end
end
