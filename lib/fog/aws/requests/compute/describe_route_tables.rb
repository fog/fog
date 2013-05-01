module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/describe_route_tables'

        # Describe all or specified route_tables
        #
        # ==== Parameters
        # * filters<~Hash> - List of filters to limit results with
        #
        # === Returns
        # * response<~Excon::Response>:
        # * body<~Hash>:
        # * 'requestId'<~String> - Id of request
        # * 'RouteTableSet'<~Array>:
        #   * 'routeTableId'<~String> - The ID of the route table. 
        #   * 'associationSet'<~Array>: - A list of associations between the route table and one or more subnets
        #     * 'routeTableAssociationId'<~String> - An identifier representing the association between a route table and a subnet
        #     * 'routeTableId'<~String> - The ID of the route table.
        #     * 'subnetId'<~String> - The ID of the subnet.
        #     * 'main'<~Boolean> - Whether this is the main route table
        #   * 'routeSet'<~Array>: - A list of associations between the route table and one or more subnets
        #     * 'destinationCidrBlock'<~String> - The CIDR address block used for the destination match
        #     * 'gatewayId'<~String> - The ID of a gateway attached to your VPC
        #     * 'instanceId'<~String> - The ID of a NAT instance in your VPC
        #     * 'instanceOwnerId'<~String> - The owner of the instance
        #     * 'networkInterfaceId'<~String> - The network interface ID
        #     * 'state'<~String> - State of the route
        #     * 'origin'<~String> - Describes how the route was created
        #   * 'propagatingVgwSet'<~Array>: - The IDs of any virtual private gateways (VGW) propagating routes
        #     * 'gatewayId'<~String> - The ID of a gateway attached to your VPC
        # * 'tagSet'<~Array>: Tags assigned to the resource.
        #   * 'key'<~String> - Tag's key
        #   * 'value'<~String> - Tag's value
        #
        # {Amazon API Reference}[http://docs.aws.amazon.com/AWSEC2/latest/APIReference/ApiReference-query-DescribeRouteTables.html]
        def describe_route_tables(filters = {})
          unless filters.is_a?(Hash)
            Fog::Logger.warning("describe_route_tables with #{filters.class} param is deprecated, use route_tables('route-table-id' => []) instead [light_black](#{caller.first})[/]")
            filters = {'route-table-id' => [*filters]}
          end
          params = Fog::AWS.indexed_filters(filters)
          request({
            'Action' => 'DescribeRouteTables',
            :idempotent => true,
            :parser => Fog::Parsers::Compute::AWS::DescribeRouteTables.new
          }.merge!(params))
        end
      end

      class Mock
        def describe_route_tables(filters = {})
          route_tables = self.data[:route_tables]

          if filters['route-table-id']
            route_tables = route_tables.reject {|route_table| route_table['routeTableId'] != filters['route-table-id']}
          end

          Excon::Response.new(
            :status => 200,
            :body   => {
              'requestId'           => Fog::AWS::Mock.request_id,
              'routeTableSet'  => route_tables
            }
          )
        end
      end
    end
  end
end
