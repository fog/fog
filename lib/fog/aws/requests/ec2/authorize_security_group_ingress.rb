module Fog
  module AWS
    class EC2

      # Add permissions to a security group
      #
      # ==== Parameters
      # * cidr_ip - CIDR range
      # * from_port - Start of port range (or -1 for ICMP wildcard)
      # * group_name - Name of group to modify
      # * ip_protocol - Ip protocol, must be in ['tcp', 'udp', 'icmp']
      # * to_port - End of port range (or -1 for ICMP wildcard)
      # * user_id - AWS Access Key ID
      #
      # === Returns
      # FIXME: docs
      def authorize_security_group_ingress(cidr_ip, from_port, group_name,
                                            ip_protocol, to_port, user_id)
        request({
          'Action' => 'AuthorizeSecurityGroupIngress',
          'CidrIp' => cidr_ip,
          'FromPort' => from_port,
          'GroupName' => group_name,
          'IpProtocol' => ip_protocol,
          'ToPort' => to_port,
          'UserId' => user_id
        }, Fog::Parsers::AWS::EC2::Basic.new)
      end

    end
  end
end
