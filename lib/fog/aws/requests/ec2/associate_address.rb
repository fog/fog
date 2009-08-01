module Fog
  module AWS
    class EC2

      # Associate an elastic IP address with an instance
      #
      # ==== Parameters
      # * instance_id<~String> - Id of instance to associate address with
      # * public_ip<~String> - Public ip to assign to instance
      #
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * 'requestId'<~String> - Id of request
      #     * 'return'<~Boolean> - success?
      def associate_address(instance_id, public_ip)
        request({
          'Action' => 'AssociateAddress',
          'InstanceId' => instance_id,
          'PublicIp' => public_ip
        }, Fog::Parsers::AWS::EC2::Basic.new)
      end

    end
  end
end