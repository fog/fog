module Fog
  module AWS
    module EC2
      class Real

        # Remove permissions from a security group
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
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'return'<~Boolean> - success?
        def revoke_security_group_ingress(options = {})
          request({
            'Action'  => 'RevokeSecurityGroupIngress',
            :parser   => Fog::Parsers::AWS::EC2::Basic.new
          }.merge!(options))
        end

      end

      class Mock

        def revoke_security_group_ingress(options = {})
          if options['GroupName'] && options['SourceSecurityGroupName'] && options['SourceSecurityGroupOwnerId']
            raise MockNotImplemented.new("Contributions welcome!")
          else
            response = Excon::Response.new
            group = @data[:security_groups][options['GroupName']]

            ingress = group['ipPermissions'].select {|permission|
              permission['fromPort']    == options['FromPort'] &&
              permission['ipProtocol']  == options['IpProtocol'] &&
              permission['toPort']      == options['ToPort'] &&
              permission['ipRanges'].first['cidrIp'] == options['CidrIp']
            }.first

            group['ipPermissions'].delete(ingress)

            response.status = 200
            response.body = {
              'requestId' => Fog::AWS::Mock.request_id,
              'return'    => true
            }
            response
          end
        end

      end
    end
  end
end
