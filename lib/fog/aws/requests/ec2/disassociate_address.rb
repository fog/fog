module Fog
  module AWS
    class EC2

      # Disassociate an elastic IP address from its instance (if any)
      #
      # ==== Parameters
      # * public_ip<~String> - Public ip to assign to instance
      #
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * 'requestId'<~String> - Id of request
      #     * 'return'<~Boolean> - success?
      def disassociate_address(public_ip)
        request({
          'Action' => 'DisassociateAddress',
          'PublicIp' => public_ip
        }, Fog::Parsers::AWS::EC2::Basic.new)
      end

    end
  end
end