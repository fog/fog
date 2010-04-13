module Fog
  module AWS
    module EC2
      class Real

        # Describe all or specified security groups
        #
        # ==== Parameters
        # * group_name<~Array> - List of groups to describe, defaults to all
        #
        # === Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'securityGroupInfo'<~Array>:
        #       * 'groupDescription'<~String> - Description of security group
        #       * 'groupName'<~String> - Name of security group
        #       * 'ipPermissions'<~Array>:
        #         * 'fromPort'<~Integer> - Start of port range (or -1 for ICMP wildcard)
        #         * 'groups'<~Array>:
        #           * 'groupName'<~String> - Name of security group
        #           * 'userId'<~String> - AWS User Id of account
        #         * 'ipProtocol'<~String> - Ip protocol, must be in ['tcp', 'udp', 'icmp']
        #         * 'ipRanges'<~Array>:
        #           * 'cidrIp'<~String> - CIDR range
        #         * 'toPort'<~Integer> - End of port range (or -1 for ICMP wildcard)
        #       * 'ownerId'<~String> - AWS Access Key Id of the owner of the security group
        def describe_security_groups(group_name = [])
          params = AWS.indexed_param('GroupName', group_name)
          request({
            'Action'  => 'DescribeSecurityGroups',
            :parser   => Fog::Parsers::AWS::EC2::DescribeSecurityGroups.new
          }.merge!(params))
        end

      end

      class Mock

        def describe_security_groups(group_name = [])
          response = Excon::Response.new
          group_name = [*group_name]
          if group_name != []
            security_group_info = @data[:security_groups].reject {|key, value| !group_name.include?(key)}.values
          else
            security_group_info = @data[:security_groups].values
          end
          if group_name.length == 0 || group_name.length == security_group_info.length
            response.status = 200
            response.body = {
              'requestId'         => Fog::AWS::Mock.request_id,
              'securityGroupInfo' => security_group_info
            }
          else
            response.status = 400
            raise(Excon::Errors.status_error({:expects => 200}, response))
          end
          response
        end

      end
    end
  end
end
