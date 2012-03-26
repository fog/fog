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
            
              response.body = {
                'requestId' => Fog::AWS::Mock.request_id,
                'vpcSet'    => [
                  'vpcId'         => Fog::AWS::Mock.request_id,
                  'state'         => 'pending',
                  'cidrBlock'     => cidrBlock,
                  'dhcpOptionsId' => Fog::AWS::Mock.request_id,
                  'tagSet'        => {}
                ]
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
