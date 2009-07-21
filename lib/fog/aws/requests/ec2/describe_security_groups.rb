module Fog
  module AWS
    class EC2

      # Describe all or specified security groups
      #
      # ==== Parameters
      # * group_name<~Array> - List of groups to describe, defaults to all
      #
      # === Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * :request_id<~String> - Id of request
      #     * :security_group_info<~Array>:
      #       * :group_description<~String> - Description of security group
      #       * :group_name<~String> - Name of security group
      #       * :ip_permissions<~Array>:
      #         * :from_port<~Integer> - Start of port range (or -1 for ICMP wildcard)
      #         * :groups<~Array>:
      #           * :group_name<~String> - Name of security group
      #           * :user_id<~String> - AWS User Id of account
      #         * :ip_protocol<~String> - Ip protocol, must be in ['tcp', 'udp', 'icmp']
      #         * :ip_ranges<~Array>:
      #           * :cidr_ip<~String> - CIDR range
      #         * :to_port<~Integer> - End of port range (or -1 for ICMP wildcard)
      #       * :owner_id<~String> - AWS Access Key Id of the owner of the security group
      def describe_security_groups(group_name = [])
        params = indexed_params('GroupName', group_name)
        request({
          'Action' => 'DescribeSecurityGroups',
        }.merge!(params), Fog::Parsers::AWS::EC2::DescribeSecurityGroups.new)
      end

    end
  end
end
