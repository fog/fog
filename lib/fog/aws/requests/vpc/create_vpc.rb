module Fog
  module AWS
    class VPC
      class Real

        require 'fog/aws/parsers/vpc/create_vpc'

        # Creates a VPC with the CIDR block you specify.
        #
        # ==== Parameters
        # * cidrBlock<~String> - The CIDR block you want the VPC to cover (e.g., 10.0.0.0/16).
        #
        # === Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'vpc'<~Array>:
        #       * 'vpcId'<~String> - The VPC's ID
        #       * 'state'<~String> - The current state of the VPC. ['pending', 'available']
        #       * 'cidrBlock'<~String> - The CIDR block the VPC covers. 
        #       * 'dhcpOptionsId'<~String> - The ID of the set of DHCP options.
        #       * 'tagSet'<~Array>: Tags assigned to the resource.
        #         * 'key'<~String> - Tag's key
        #         * 'value'<~String> - Tag's value
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/2011-07-15/APIReference/index.html?ApiReference-query-CreateVpc.html]
        def create_vpc(cidrBlock)
          request(
            'Action'    => 'CreateVpc',
            'CidrBlock' => cidrBlock,
            :parser     => Fog::Parsers::AWS::VPC::CreateVpc.new
          )
        end
      end
      
      class Mock
        def create_vpc(cidrBlock)
          Excon::Response.new.tap do |response|
            if cidrBlock
              response.status = 200
            
              response.body = {
                'requestId' => Fog::AWS::Mock.request_id,
                'vpc' => {}  # TODO
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
