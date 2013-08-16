module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/create_route_table'

        # Creates a VPC with the CIDR block you specify.
        #
        # ==== Parameters
        # * cidrBlock<~String> - The CIDR block you want the VPC to cover (e.g., 10.0.0.0/16).
        # * options<~Hash>:
        #   * InstanceTenancy<~String> - The allowed tenancy of instances launched into the VPC. A value of default 
        #     means instances can be launched with any tenancy; a value of dedicated means instances must be launched with tenancy as dedicated.
        #     please not that the documentation is incorrect instanceTenancy will not work while InstanceTenancy will
        #
        # === Returns
        # * response<~Excon::Response>:
        # * body<~Hash>:
        # * 'requestId'<~String> - Id of request
        # * 'vpc'<~Array>:
        # * 'vpcId'<~String> - The VPC's ID
        # * 'state'<~String> - The current state of the VPC. ['pending', 'available']
        # * 'cidrBlock'<~String> - The CIDR block the VPC covers.
        # * 'dhcpOptionsId'<~String> - The ID of the set of DHCP options.
        # * 'tagSet'<~Array>: Tags assigned to the resource.
        # * 'key'<~String> - Tag's key
        # * 'value'<~String> - Tag's value
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/2011-07-15/APIReference/index.html?ApiReference-query-CreateVpc.html]
        def create_route_table(vpc_id, options = {})
          request({
            'Action' => 'CreateRouteTable',
            'VpcId' => vpc_id,
            :parser => Fog::Parsers::Compute::AWS::CreateRouteTable.new
          }.merge!(options))

        end
      end
      
      class Mock
        def create_route_table(vpc_id, options={})
          self.data[:route_tables] = {
              'routeTableId' => Fog::AWS::Mock.request_id,
              'attachmentSet' => {},
              'tagSet' => {}
            }
          Excon::Response.new(
            :status => 200,
            :body => {
              'requestId'=> Fog::AWS::Mock.request_id,
              'routeTableSet' => self.data[:route_tables]
            }
            )
        end
      end
    end
  end
end
