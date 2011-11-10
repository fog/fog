module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/basic'

        # Remove permissions from a security group
        #
        # ==== Parameters
        # * group_name<~String> - Name of group
        # * options<~Hash>:
        #   * 'SourceSecurityGroupName'<~String> - Name of security group to authorize
        #   * 'SourceSecurityGroupOwnerId'<~String> - Name of owner to authorize
        #   or
        #   * 'CidrIp'<~String> - CIDR range
        #   * 'FromPort'<~Integer> - Start of port range (or -1 for ICMP wildcard)
        #   * 'IpProtocol'<~String> - Ip protocol, must be in ['tcp', 'udp', 'icmp']
        #   * 'ToPort'<~Integer> - End of port range (or -1 for ICMP wildcard)
        #   or
        #   * 'IpPermissions'<~Array>:
        #     * permission<~Hash>:
        #       * 'FromPort'<~Integer> - Start of port range (or -1 for ICMP wildcard)
        #       * 'Groups'<~Array>:
        #         * group<~Hash>:
        #           * 'GroupName'<~String> - Name of security group to authorize
        #           * 'UserId'<~String> - Name of owner to authorize
        #       * 'IpProtocol'<~String> - Ip protocol, must be in ['tcp', 'udp', 'icmp']
        #       * 'IpRanges'<~Array>:
        #         * ip_range<~Hash>:
        #           * 'CidrIp'<~String> - CIDR range
        #       * 'ToPort'<~Integer> - End of port range (or -1 for ICMP wildcard)
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
            Fog::Logger.deprecation("Fog::AWS::Compute#revoke_security_group_ingress now requires the 'group_name' parameter. Only specifying an options hash is now deprecated [light_black](#{caller.first})[/]")
            options = group_name
            group_name = options.delete('GroupName')
          end

          if ip_permissions = options.delete('IpPermissions')
            options.merge!(indexed_ip_permissions_params(ip_permissions))
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
            Fog::Logger.deprecation("Fog::AWS::Compute#revoke_security_group_ingress now requires the 'group_name' parameter. Only specifying an options hash is now deprecated [light_black](#{caller.first})[/]")
            options = group_name
            group_name = options.delete('GroupName')
          end

          verify_permission_options(options)

          response = Excon::Response.new
          group = self.data[:security_groups][group_name]

          if group
            normalized_permissions = normalize_permissions(options)

            normalized_permissions.each do |permission|
              if matching_permission = find_matching_permission(group, permission)
                matching_permission['ipRanges'] -= permission['ipRanges']
                matching_permission['groups'] -= permission['groups']

                if matching_permission['ipRanges'].empty? && matching_permission['groups'].empty?
                  group['ipPermissions'].delete(matching_permission)
                end
              end
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
