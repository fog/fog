module Fog
  module AWS
    class EC2

      # Add permissions to a security group
      #
      # ==== Parameters
      # * options<~Hash>:
      #   * 'GroupName'<~String> - Name of group
      #   * 'SourceSecurityGroupName'<~String> - Name of security group to authorize
      #   * 'SourceSecurityGroupOwnerId'<~String> - Name of owner to authorize
      #   or
      #   * 'CidrIp' - CIDR range
      #   * 'FromPort' - Start of port range (or -1 for ICMP wildcard)
      #   * 'GroupName' - Name of group to modify
      #   * 'IpProtocol' - Ip protocol, must be in ['tcp', 'udp', 'icmp']
      #   * 'ToPort' - End of port range (or -1 for ICMP wildcard)
      #
      # === Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * 'requestId'<~String> - Id of request
      #     * 'return'<~Boolean> - success?
      def authorize_security_group_ingress(options = {})
        request({
          'Action' => 'AuthorizeSecurityGroupIngress'
        }.merge!(options), Fog::Parsers::AWS::EC2::Basic.new)
      end

    end
  end
end
