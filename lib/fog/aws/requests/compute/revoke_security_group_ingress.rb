module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/basic'

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
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-RevokeSecurityGroupIngress.html]
        def revoke_security_group_ingress(group_name, options = {})
          if group_name.is_a?(Hash)
            Fog::Logger.warning("Fog::AWS::Compute#revoke_security_group_ingress now requires the 'group_name' parameter. Only specifying an options hash is now deprecated [light_black](#{caller.first})[/]")
            options = group_name
            group_name = options['GroupName']
          end
          request({
            'Action'    => 'RevokeSecurityGroupIngress',
            'GroupName' => group_name,
            :idempotent => true,
            :parser     => Fog::Parsers::Compute::AWS::Basic.new
          }.merge!(options))
        end

      end

      class Mock

        def revoke_security_group_ingress(group_name, options = {})
          if group_name.is_a?(Hash)
            Fog::Logger.warning("Fog::AWS::Compute#revoke_security_group_ingress now requires the 'group_name' parameter. Only specifying an options hash is now deprecated [light_black](#{caller.first})[/]")
            options = group_name
            group_name = options['GroupName']
          end
          response = Excon::Response.new
          group = self.data[:security_groups][group_name]
          if group
            if source_group_name = options['SourceSecurityGroupName']
              group['ipPermissions'].delete_if do |permission|
                if source_owner_id = options['SourceSecurityGroupOwnerId']
                  permission['groups'].first['groupName'] == source_group_name && permission['groups'].first['userId'] == source_owner_id
                else
                  permission['groups'].first['groupName'] == source_group_name
                end
              end
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
            raise Fog::Compute::AWS::NotFound.new("The security group '#{group_name}' does not exist")
          end
        end

      end
    end
  end
end
