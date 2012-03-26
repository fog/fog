module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/describe_vpcs'

        # Describe all or specified vpcs
        #
        # ==== Parameters
        # * filters<~Hash> - List of filters to limit results with
        #
        # === Returns
        # * response<~Excon::Response>:
        # * body<~Hash>:
        # * 'requestId'<~String> - Id of request
        # * 'vpcSet'<~Array>:
        # * 'vpcId'<~String> - The VPC's ID
        # * 'state'<~String> - The current state of the VPC. ['pending', 'available']
        # * 'cidrBlock'<~String> - The CIDR block the VPC covers.
        # * 'dhcpOptionsId'<~String> - The ID of the set of DHCP options.
        # * 'tagSet'<~Array>: Tags assigned to the resource.
        # * 'key'<~String> - Tag's key
        # * 'value'<~String> - Tag's value
        # * 'instanceTenancy'<~String> - The allowed tenancy of instances launched into the VPC.
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/2011-07-15/APIReference/index.html?ApiReference-query-DescribeVpcs.html]
        def describe_vpcs(filters = {})
          unless filters.is_a?(Hash)
            Fog::Logger.warning("describe_vpcs with #{filters.class} param is deprecated, use describe_vpcs('vpc-id' => []) instead [light_black](#{caller.first})[/]")
            filters = {'vpc-id' => [*filters]}
          end
          params = Fog::AWS.indexed_filters(filters)
          request({
            'Action' => 'DescribeVpcs',
            :idempotent => true,
            :parser => Fog::Parsers::Compute::AWS::DescribeVpcs.new
          }.merge!(params))
        end
      end
      
      class Mock
        def describe_vpcs(filters = {})
          Excon::Response.new.tap do |response|
            response.status = 200
            response.body = {
              'requestId' => Fog::AWS::Mock.request_id,
              'vpcSet'    => [
                'vpcId'           => Fog::AWS::Mock.request_id,
                'state'           => 'pending',
                'cidrBlock'       => '10.255.255.0/24',
                'dhcpOptionsId'   => Fog::AWS::Mock.request_id,
                'instanceTenancy' => 'default',
                'tagSet'          =>  {}
              ]
            }
          end
        end
      end
    end
  end
end
