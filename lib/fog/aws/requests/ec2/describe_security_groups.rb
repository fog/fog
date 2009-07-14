module Fog
  module AWS
    class EC2

      # Describe all or specified security groups
      #
      # ==== Parameters
      # * group_name<~Array> - List of groups to describe, defaults to all
      #
      # === Returns
      # FIXME: docs
      def describe_security_groups(group_name = [])
        params = indexed_params('GroupName', group_name)
        request({
          'Action' => 'DescribeSecurityGroups',
        }.merge!(params), Fog::Parsers::AWS::EC2::DescribeSecurityGroups.new)
      end

    end
  end
end
