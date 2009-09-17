unless Fog.mocking?

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

else

  module Fog
    module AWS
      class EC2

        # TODO: handle the GroupName/Source/Source case
        def authorize_security_group_ingress(options = {})
          response = Fog::Response.new
          group = Fog::AWS::EC2.data[:security_groups][options['GroupName']]

          group['ipPermissions'] ||= []
          group['ipPermissions'] << {
            'groups'      => [],
            'fromPort'    => options['FromPort'],
            'ipRanges'    => [{ 'cidrIp' => options['CidrIp'] }],
            'ipProtocol'  => options['IpProtocol'],
            'toPort'      => options['ToPort']
          }

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
