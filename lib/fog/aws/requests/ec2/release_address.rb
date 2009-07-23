module Fog
  module AWS
    class EC2

      # Release an elastic IP address.
      #
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * :request_id<~String> - Id of request
      #     * :return<~Boolean> - success?
      def release_address(public_ip)
        request({
          'Action' => 'ReleaseAddress',
          'PublicIp' => public_ip
        }, Fog::Parsers::AWS::EC2::Basic.new)
      end

    end
  end
end
