module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/basic'

        # Add permissions to a security group
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
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-AuthorizeSecurityGroupIngress.html]
        def authorize_security_group_ingress(group_name, options = {})
          if group_name.is_a?(Hash)
            Fog::Logger.deprecation("Fog::AWS::Compute#authorize_security_group_ingress now requires the 'group_name' parameter. Only specifying an options hash is now deprecated [light_black](#{caller.first})[/]")
            options = group_name
            group_name = options.delete('GroupName')
          end

          if ip_permissions = options.delete('IpPermissions')
            options.merge!(indexed_ip_permissions_params(ip_permissions))
          end

          request({
            'Action'    => 'AuthorizeSecurityGroupIngress',
            'GroupName' => group_name,
            :idempotent => true,
            :parser     => Fog::Parsers::Compute::AWS::Basic.new
          }.merge!(options))
        end

        private

        def indexed_ip_permissions_params(ip_permissions)
          params = {}
          ip_permissions.each_with_index do |permission, key_index|
            key_index += 1
            params[format('IpPermissions.%d.IpProtocol', key_index)] = permission['IpProtocol']
            params[format('IpPermissions.%d.FromPort', key_index)] = permission['FromPort']
            params[format('IpPermissions.%d.ToPort', key_index)] = permission['ToPort']
            (permission['Groups'] || []).each_with_index do |group, group_index|
              group_index += 1
              params[format('IpPermissions.%d.Groups.%d.UserId', key_index, group_index)] = group['UserId']
              params[format('IpPermissions.%d.Groups.%d.GroupName', key_index, group_index)] = group['GroupName']
              params[format('IpPermissions.%d.Groups.%d.GroupId', key_index, group_index)] = group['GroupId']
            end
            (permission['IpRanges'] || []).each_with_index do |ip_range, range_index|
              range_index += 1
              params[format('IpPermissions.%d.IpRanges.%d.CidrIp', key_index, range_index)] = ip_range['CidrIp']
            end
          end
          params.reject {|k, v| v.nil? }
        end

      end

      class Mock

        def authorize_security_group_ingress(group_name, options = {})
          if group_name.is_a?(Hash)
            Fog::Logger.deprecation("Fog::AWS::Compute#authorize_security_group_ingress now requires the 'group_name' parameter. Only specifying an options hash is now deprecated [light_black](#{caller.first})[/]")
            options = group_name
            group_name = options.delete('GroupName')
          end

          verify_permission_options(options)

          response = Excon::Response.new
          group = self.data[:security_groups][group_name]

          if group
            normalized_permissions = normalize_permissions(options)

            normalized_permissions.each do |permission|
              if matching_group_permission = find_matching_permission(group, permission)
                if permission['groups'].any? {|pg| matching_group_permission['groups'].include?(pg) }
                  raise Fog::Compute::AWS::Error, "InvalidPermission.Duplicate => The permission '123' has already been authorized in the specified group"
                end

                if permission['ipRanges'].any? {|pr| matching_group_permission['ipRanges'].include?(pr) }
                  raise Fog::Compute::AWS::Error, "InvalidPermission.Duplicate => The permission '123' has already been authorized in the specified group"
                end
              end
            end

            normalized_permissions.each do |permission|
              if matching_group_permission = find_matching_permission(group, permission)
                matching_group_permission['groups'] += permission['groups']
                matching_group_permission['ipRanges'] += permission['ipRanges']
              else
                group['ipPermissions'] << permission
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

        private

        def verify_permission_options(options)
          if options.empty?
            raise Fog::Compute::AWS::Error.new("InvalidRequest => The request received was invalid.")
          end
          if options['IpProtocol'] && !['tcp', 'udp', 'icmp'].include?(options['IpProtocol'])
            raise Fog::Compute::AWS::Error.new("InvalidPermission.Malformed => Unsupported IP protocol \"#{options['IpProtocol']}\"  - supported: [tcp, udp, icmp]")
          end
          if options['IpProtocol'] && (!options['FromPort'] || !options['ToPort'])
            raise Fog::Compute::AWS::Error.new("InvalidPermission.Malformed => TCP/UDP port (-1) out of range")
          end
          if options.has_key?('IpPermissions')
            if !options['IpPermissions'].is_a?(Array) || options['IpPermissions'].empty?
              raise Fog::Compute::AWS::Error.new("InvalidRequest => The request received was invalid.")
            end
            options['IpPermissions'].each {|p| verify_permission_options(p) }
          end
        end

        def normalize_permissions(options)
          normalized_permissions = []

          if options['SourceSecurityGroupName']
            ['tcp', 'udp'].each do |protocol|
              normalized_permissions << {
                'ipProtocol' => protocol,
                'fromPort' => 1,
                'toPort' => 65535,
                'groups' => [{'groupName' => options['SourceSecurityGroupName'], 'userId' => options['SourceSecurityGroupOwnerId'] || self.data[:owner_id]}],
                'ipRanges' => []
              }
            end
            normalized_permissions << {
              'ipProtocol' => 'icmp',
              'fromPort' => -1,
              'toPort' => -1,
              'groups' => [{'groupName' => options['SourceSecurityGroupName'], 'userId' => options['SourceSecurityGroupOwnerId'] || self.data[:owner_id]}],
              'ipRanges' => []
            }
          elsif options['CidrIp']
            normalized_permissions << {
              'ipProtocol' => options['IpProtocol'],
              'fromPort' => Integer(options['FromPort']),
              'toPort' => Integer(options['ToPort']),
              'groups' => [],
              'ipRanges' => [{'cidrIp' => options['CidrIp']}]
            }
          elsif options['IpPermissions']
            options['IpPermissions'].each do |permission|
              normalized_permissions << {
                'ipProtocol' => permission['IpProtocol'],
                'fromPort' => Integer(permission['FromPort']),
                'toPort' => Integer(permission['ToPort']),
                'groups' => (permission['Groups'] || []).map {|g| {'groupName' => g['GroupName'], 'userId' => g['UserId'] || self.data[:owner_id]} },
                'ipRanges' => (permission['IpRanges'] || []).map {|r| { 'cidrIp' => r['CidrIp'] } }
              }
            end
          end

          normalized_permissions
        end

        def find_matching_permission(group, permission)
          group['ipPermissions'].detect {|group_permission|
            permission['ipProtocol'] == group_permission['ipProtocol'] &&
            permission['fromPort'] == group_permission['fromPort'] &&
            permission['toPort'] == group_permission['toPort'] }
        end

      end
    end
  end
end
