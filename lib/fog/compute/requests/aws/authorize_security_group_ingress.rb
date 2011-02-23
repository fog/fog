module Fog
  module AWS
    class Compute
      class Real

        require 'fog/compute/parsers/aws/basic'

        # Add permissions to a security group
        #
        # ==== Parameters
        # * group_name<~String> - Name of group
        # * options<~Hash>:
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
        def authorize_security_group_ingress(group_name, options = {})
          if group_name.is_a?(Hash)
            location = caller.first
            warning = "[yellow][WARN] Fog::AWS::Compute#authorize_security_group_ingress now requires the 'group_name' parameter. Only specifying an options hash is now deprecated"
            warning << " [light_black](" << location << ")[/] "
            Formatador.display_line(warning)
            options = group_name
            group_name = options['GroupName']
          end
          request({
            'Action'    => 'AuthorizeSecurityGroupIngress',
            'GroupName' => group_name,
            :idempotent => true,
            :parser     => Fog::Parsers::AWS::Compute::Basic.new
          }.merge!(options))
        end

      end

      class Mock

        def authorize_security_group_ingress(group_name, options = {})
          if group_name.is_a?(Hash)
            location = caller.first
            warning = "[yellow][WARN] Fog::AWS::Compute#authorize_security_group_ingress now requires the 'group_name' parameter. Only specifying an options hash is now deprecated"
            warning << " [light_black](" << location << ")[/] "
            Formatador.display_line(warning)
            options = group_name
            group_name = options['GroupName']
          end

          response = Excon::Response.new
          group = @data[:security_groups][group_name]

          if group
            group['ipPermissions'] ||= []
            if group_name && options['SourceSecurityGroupName'] && options['SourceSecurityGroupOwnerId']
              ['tcp', 'udp'].each do |protocol|
                group['ipPermissions'] << {
                  'groups'      => [{'groupName' => group_name, 'userId' => @owner_id}],
                  'fromPort'    => 1,
                  'ipRanges'    => [],
                  'ipProtocol'  => protocol,
                  'toPort'      => 65535
                }
              end
              group['ipPermissions'] << {
                'groups'      => [{'groupName' => group_name, 'userId' => @owner_id}],
                'fromPort'    => -1,
                'ipRanges'    => [],
                'ipProtocol'  => 'icmp',
                'toPort'      => -1
              }
            else
              group['ipPermissions'] << {
                'groups'      => [],
                'fromPort'    => options['FromPort'],
                'ipRanges'    => [],
                'ipProtocol'  => options['IpProtocol'],
                'toPort'      => options['ToPort']
              }
              if options['CidrIp']
                group['ipPermissions'].last['ipRanges'] << { 'cidrIp' => options['CidrIp'] }
              end
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
