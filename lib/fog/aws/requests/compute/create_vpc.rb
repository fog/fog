module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/create_vpc'

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
        def create_vpc(cidrBlock, options = {})
          request({
            'Action' => 'CreateVpc',
            'CidrBlock' => cidrBlock,
            :parser => Fog::Parsers::Compute::AWS::CreateVpc.new
          }.merge!(options))

        end
      end

      class Mock
        def create_vpc(cidrBlock)
          Excon::Response.new.tap do |response|
            if cidrBlock
              response.status = 200
              vpc_id = Fog::AWS::Mock.vpc_id
              vpc = {
                'vpcId'         => vpc_id,
                'state'         => 'pending',
                'cidrBlock'     => cidrBlock,
                'dhcpOptionsId' => Fog::AWS::Mock.request_id,
                'tagSet'        => {}
              }
              self.data[:vpcs].push(vpc)

              #Creates a default route for the subnet
              default_route = self.route_tables.new(:vpc_id => vpc_id)
              default_route.save

              # You are not able to push a main route in the normal AWS, so we are re-implementing some of the
              # associate_route_table here in order to accomplish this.
              route_table = self.data[:route_tables].find { |routetable| routetable["routeTableId"].eql? default_route.id }

              # This pushes a main route to the associationSet
              # add_route_association(routeTableId, subnetId, main=false) is declared in assocate_route_table.rb
              assoc = add_route_association(default_route.id, nil, true)
              route_table["associationSet"].push(assoc)

              # Create a default network ACL
              default_nacl = self.network_acls.new(:vpc_id => vpc_id)
              default_nacl.save
              # Manually override since Amazon doesn't let you create a default one
              self.data[:network_acls][default_nacl.network_acl_id]['default'] = true

              response.body = {
                'requestId' => Fog::AWS::Mock.request_id,
                'vpcSet'    => [vpc]
              }
            else
              response.status = 400
              response.body = {
                'Code' => 'InvalidParameterValue'
              }
              if cidrBlock.empty?
                response.body['Message'] = "Invalid value '' for cidrBlock. Must be specified."
              end
            end
          end
        end
      end
    end
  end
end
