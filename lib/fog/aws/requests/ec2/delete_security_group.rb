module Fog
  module AWS
    class EC2

      # Delete a security group that you own
      #
      # ==== Parameters
      # * group_name<~String> - Name of the security group.
      #
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * 'requestId'<~String> - Id of request
      #     * 'return'<~Boolean> - success?
      def delete_security_group(name)
        request({
          'Action' => 'DeleteSecurityGroup',
          'GroupName' => name
        }, Fog::Parsers::AWS::EC2::Basic.new)
      end

    end
  end
end
