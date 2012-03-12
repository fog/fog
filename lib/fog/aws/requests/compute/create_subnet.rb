module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/create_subnet'

        # Creates a Subnet with the CIDR block you specify.
        #
        # ==== Parameters
        # * vpcId<~String> - The ID of the VPC where you want to create the subnet.
        # * cidrBlock<~String> - The CIDR block you want the Subnet to cover (e.g., 10.0.0.0/16).
        # * options<~Hash>:
        #   * AvailabilityZone<~String> - The Availability Zone you want the subnet in. Default: AWS selects a zone for you (recommended)
        #
        # === Returns
        # * response<~Excon::Response>:
        # * body<~Hash>:
        # * 'requestId'<~String> - Id of request
        # * 'subnet'<~Array>:
        # * 'subnetId'<~String> - The Subnet's ID
        # * 'state'<~String> - The current state of the Subnet. ['pending', 'available']
        # * 'cidrBlock'<~String> - The CIDR block the Subnet covers.
        # * 'AvailableIpAddressCount'<~Integer> - The number of unused IP addresses in the subnet (the IP addresses for any stopped 
        #   instances are considered unavailable)
        # * 'AvailabilityZone'<~String> - The Availability Zone the subnet is in
        # * 'tagSet'<~Array>: Tags assigned to the resource.
        # * 'key'<~String> - Tag's key
        # * 'value'<~String> - Tag's value
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/2011-07-15/APIReference/ApiReference-query-CreateSubnet.html]
        def create_subnet(vpcId, cidrBlock, options = {})
          request({
            'Action'     => 'CreateSubnet',
            'VpcId'      => vpcId,
            'CidrBlock'  => cidrBlock,
            :parser      => Fog::Parsers::Compute::AWS::CreateSubnet.new
          }.merge!(options))

        end
      end
      
      class Mock
        def create_subnet(vpcId, cidrBlock, options = {})
          av_zone = options['AvailabilityZone'].nil? ? 'us-east-1c' : options['AvailabilityZone']
          Excon::Response.new.tap do |response|
            if cidrBlock  && vpcId
              response.status = 200
            
              response.body = {
                'requestId'    => Fog::AWS::Mock.request_id,
                'subnetSet'    => [
                  'subnetId'                 => Fog::AWS::Mock.request_id,
                  'state'                    => 'pending',
                  'vpcId'                    => Fog::AWS::Mock.request_id,
                  'cidrBlock'                => cidrBlock,
                  'availableIpAddressCount'  => 16,
                  'availabilityZone'         => av_zone,
                  'tagSet'                   => {}
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
              if vpcId.empty?
                response.body['Message'] = "Invalid value '' for vpcId. Must be specified."
              end
            end
          end
        end
      end
    end
  end
end
