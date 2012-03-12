module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/describe_subnets'

        # Describe all or specified subnets
        #
        # ==== Parameters
        # * filters<~Hash> - List of filters to limit results with
        #
        # === Returns
        # * response<~Excon::Response>:
        # * body<~Hash>:
        # * 'requestId'<~String> - Id of request
        # * 'subnetSet'<~Array>:
        # * 'subnetId'<~String> - The Subnet's ID
        # * 'state'<~String> - The current state of the Subnet. ['pending', 'available']
        # * 'vpcId'<~String> - The ID of the VPC the subnet is in
        # * 'cidrBlock'<~String> - The CIDR block the Subnet covers.
        # * 'availableIpAddressCount'<~Integer> - The number of unused IP addresses in the subnet (the IP addresses for any 
        #   stopped instances are considered unavailable)
        # * 'availabilityZone'<~String> - The Availability Zone the subnet is in.
        # * 'tagSet'<~Array>: Tags assigned to the resource.
        # * 'key'<~String> - Tag's key
        # * 'value'<~String> - Tag's value
        # * 'instanceTenancy'<~String> - The allowed tenancy of instances launched into the Subnet.
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/2011-07-15/APIReference/index.html?ApiReference-query-DescribeSubnets.html]
        def describe_subnets(filters = {})
          unless filters.is_a?(Hash)
            Fog::Logger.warning("describe_subnets with #{filters.class} param is deprecated, use describe_subnets('subnet-id' => []) instead [light_black](#{caller.first})[/]")
            filters = {'subnet-id' => [*filters]}
          end
          params = Fog::AWS.indexed_filters(filters)
          request({
            'Action'    => 'DescribeSubnets',
            :idempotent => true,
            :parser     => Fog::Parsers::Compute::AWS::DescribeSubnets.new
          }.merge!(params))
        end
      end
      
      class Mock
        def describe_subnets(filters = {})
          Excon::Response.new.tap do |response|
            response.status = 200
            response.body = {
              'requestId'  => Fog::AWS::Mock.request_id,
              'subnetSet'  => [
                'subnetId'                 => Fog::AWS::Mock.request_id,
                'state'                    => 'pending',
                'vpcId'                    => Fog::AWS::Mock.request_id,
                'cidrBlock'                => '10.255.255.0/24',
                'availableIpAddressCount'  => 255,
                'availabilityZone'         => 'us-east-1c',
                'tagSet'                   => {}
              ]
            }
          end
        end
      end
    end
  end
end
