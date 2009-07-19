module Fog
  module AWS
    class EC2

      # Remove permissions from a security group
      #
      # ==== Parameters
      # * options<~Hash>:
      #   * :group_name<~String> - Name of group
      #   * :source_security_group_name<~String> - Name of security group to authorize
      #   * :source_security_group_owner_id<~String> - Name of owner to authorize
      #   or
      #   * :cidr_ip - CIDR range
      #   * :from_port - Start of port range (or -1 for ICMP wildcard)
      #   * :group_name - Name of group to modify
      #   * :ip_protocol - Ip protocol, must be in ['tcp', 'udp', 'icmp']
      #   * :to_port - End of port range (or -1 for ICMP wildcard)
      #
      # === Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * :return<~Boolean> - success?
      def revoke_security_group_ingress(options = {})
        request({
          'Action' => 'RevokeSecurityGroupIngress',
          'CidrIp' => options[:cidr_ip],
          'FromPort' => options[:from_port],
          'GroupName' => options[:group_name],
          'IpProtocol' => options[:ip_protocol],
          'SourceSecurityGroupName' => options[:source_security_group_name],
          'SourceSecurityGroupOwnerId' => options[:source_security_group_owner_id],
          'ToPort' => options[:to_port]
        }, Fog::Parsers::AWS::EC2::Basic.new)
      end

    end
  end
end
