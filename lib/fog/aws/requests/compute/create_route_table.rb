module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/create_route_table'

        # Creates a RouteTable within a givein VPC
        #
        # ==== Parameters
        # * vpcId<~String> - The ID of the VPC where you want to create the subnet.
        #
        # === Returns
        # * response<~Excon::Response>:
        # * body<~Hash>:
        # * 'requestId'<~String> - Id of request
        # * 'routeTable'<~Array>:
        # * 'routeTableId'<~String> - The RouteTables's ID
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
        def create_route_table(vpcId)
          request({
            'Action'     => 'CreateRouteTable',
            'VpcId'      => vpcId,
            :parser      => Fog::Parsers::Compute::AWS::CreateRouteTable.new
          })

        end
      end

      class Mock
        def create_route_table(vpcId)
          Excon::Response.new.tap do |response|
            if cidrBlock  && vpcId
              response.status = 200
              self.data[:route_tables].push({
                'routeTableId'                 => Fog::AWS::Mock.request_id,
                'vpcId'                    => vpcId,
                'routeSet'                 => {},
                'associationSet'           => {},
                'propagationVgwSet'        => {},
                'tagSet'                   => {}
              })

              response.body = {
                'requestId'    => Fog::AWS::Mock.request_id,
                'routeTableSet'    => self.data[:route_tables]
              }
            else
              response.status = 400
              response.body = {
                'Code' => 'InvalidParameterValue'
              }
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
