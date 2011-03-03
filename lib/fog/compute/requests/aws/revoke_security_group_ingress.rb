module Fog
  module AWS
    class Compute
      class Real

        require 'fog/compute/parsers/aws/basic'

        # Remove permissions from a security group
        #
        # ==== Parameters
        # * 'GroupName'<~String> - Name of group
        # * options<~Hash>:
        #   * 'SourceSecurityGroupName'<~String> - Name of security group to authorize
        #   * 'SourceSecurityGroupOwnerId'<~String> - Name of owner to authorize
        #   or
        #   * 'CidrIp' - CIDR range
        #   * 'FromPort' - Start of port range (or -1 for ICMP wildcard)
        #   * 'IpProtocol' - Ip protocol, must be in ['tcp', 'udp', 'icmp']
        #   * 'ToPort' - End of port range (or -1 for ICMP wildcard)
        #
        # === Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'return'<~Boolean> - success?
        def revoke_security_group_ingress(group_name, options = {})
          if group_name.is_a?(Hash)
            location = caller.first
            warning = "[yellow][WARN] Fog::AWS::Compute#revoke_security_group_ingress now requires the 'group_name' parameter. Only specifying an options hash is now deprecated"
            warning << " [light_black](" << location << ")[/] "
            Formatador.display_line(warning)
            options = group_name
            group_name = options['GroupName']
          end
          request({
            'Action'    => 'RevokeSecurityGroupIngress',
            'GroupName' => group_name,
            :idempotent => true,
            :parser     => Fog::Parsers::AWS::Compute::Basic.new
          }.merge!(options))
        end

      end

      class Mock

        def revoke_security_group_ingress(group_name, options = {})
          if group_name.is_a?(Hash)
            location = caller.first
            warning = "[yellow][WARN] Fog::AWS::Compute#revoke_security_group_ingress now requires the 'group_name' parameter. Only specifying an options hash is now deprecated"
            warning << " [light_black](" << location << ")[/] "
            Formatador.display_line(warning)
            options = group_name
            group_name = options['GroupName']
          end
          response = Excon::Response.new
          group = @data[:security_groups][group_name]
          if group
            if options['SourceSecurityGroupName'] && options['SourceSecurityGroupOwnerId']
              group['ipPermissions'].delete_if {|permission|
                permission['groups'].first['groupName'] == group_name
              }
            else
              ingress = group['ipPermissions'].select {|permission|
                permission['fromPort']    == options['FromPort'] &&
                permission['ipProtocol']  == options['IpProtocol'] &&
                permission['toPort']      == options['ToPort'] &&
                (
                  permission['ipRanges'].empty? ||
                  (
                    permission['ipRanges'].first &&
                    permission['ipRanges'].first['cidrIp'] == options['CidrIp']
                  )
                )
              }.first
              group['ipPermissions'].delete(ingress)
            end
            response.status = 200
            response.body = {
              'requestId' => Fog::AWS::Mock.request_id,
              'return'    => true
            }
            response
          else
            raise Fog::AWS::Compute::NotFound.new("The security group '#{group_name}' does not exist")
          end
        end

      end
    end
  end
end
