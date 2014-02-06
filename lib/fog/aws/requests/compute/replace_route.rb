module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/basic'

        # Replaces a route in a route table within a VPC.
        #
        # ==== Parameters
        # * RouteTableId<~String> - The ID of the route table for the route.
        # * DestinationCidrBlock<~String> - The CIDR address block used for the destination match. Routing decisions are based on the most specific match.
        # * GatewayId<~String> - The ID of an Internet gateway attached to your VPC.
        # * InstanceId<~String> - The ID of a NAT instance in your VPC. The operation fails if you specify an instance ID unless exactly one network interface is attached.
        # * NetworkInterfaceId<~String> - The ID of a network interface.
        #
        # === Returns
        # * response<~Excon::Response>:
        # * body<~Hash>:
        # * 'requestId'<~String> - Id of the request
        # * 'return'<~Boolean> - Returns true if the request succeeds. Otherwise, returns an error.
        #
        # {Amazon API Reference}[http://docs.aws.amazon.com/AWSEC2/latest/APIReference/ApiReference-query-ReplaceRoute.html]
        # def replace_route(route_table_id, destination_cidr_block, internet_gateway_id=nil, instance_id=nil, network_interface_id=nil)
        #   request_vars = {
        #     'Action'                => 'ReplaceRoute',
        #     'RouteTableId'          => route_table_id,
        #     'DestinationCidrBlock'  => destination_cidr_block,
        #     :parser                 => Fog::Parsers::Compute::AWS::Basic.new
        #   }
        #   if internet_gateway_id
        #     request_vars['GatewayId'] = internet_gateway_id
        #   elsif instance_id
        #     request_vars['InstanceId'] = instance_id
        #   elsif network_interface_id
        #     request_vars['NetworkInterfaceId'] = network_interface_id
        #   end
        #   request(request_vars)
        # end

        # Replaces a route in a route table within a VPC.
        #
        # ==== Parameters
        # * RouteTableId<~String> - The ID of the route table for the route.
        # * options<~Hash>:
        #   * DestinationCidrBlock<~String> - The CIDR address block used for the destination match. Routing decisions are based on the most specific match.
        #   * GatewayId<~String> - The ID of an Internet gateway attached to your VPC.
        #   * InstanceId<~String> - The ID of a NAT instance in your VPC. The operation fails if you specify an instance ID unless exactly one network interface is attached.
        #   * NetworkInterfaceId<~String> - The ID of a network interface.
        #
        # === Returns
        # * response<~Excon::Response>:
        # * body<~Hash>:
        # * 'requestId'<~String> - Id of the request
        # * 'return'<~Boolean> - Returns true if the request succeeds. Otherwise, returns an error.
        #
        # {Amazon API Reference}[http://docs.aws.amazon.com/AWSEC2/latest/APIReference/ApiReference-query-ReplaceRoute.html]
        def replace_route(route_table_id, options = {})
          request({
            'Action' => 'ReplaceRoute',
            'RouteTableId' => route_table_id,
            :idempotent => true,
            :parser => Fog::Parsers::Compute::AWS::Basic.new
          }.merge!(options))

        end
      end

      class Mock

        def replace_route(route_table_id, options = {})
          options['instanceOwnerId'] = nil
          route_table = self.data[:route_tables].find { |routetable| routetable["routeTableId"].eql? route_table_id }
          if !route_table.nil? && options['destinationCidrBlock']
            if !options['gatewayId'].nil? || !options['instanceId'].nil? || !options['networkInterfaceId'].nil?
              if !options['gatewayId'].nil? && self.internet_gateways.all('internet-gateway-id'=>options['gatewayId']).first.nil?
                raise Fog::Compute::AWS::NotFound.new("The gateway ID '#{options['gatewayId']}' does not exist")
              elsif !options['instanceId'].nil? && self.servers.all('instance-id'=>options['instanceId']).first.nil?
                raise Fog::Compute::AWS::NotFound.new("The instance ID '#{options['instanceId']}' does not exist")
              elsif !options['networkInterfaceId'].nil? && self.network_interfaces.all('networkInterfaceId'=>options['networkInterfaceId']).first.nil?
                raise Fog::Compute::AWS::NotFound.new("The networkInterface ID '#{options['networkInterfaceId']}' does not exist")
              elsif route_table['routeSet'].find { |route| route['destinationCidrBlock'].eql? options['destinationCidrBlock'] }.nil?
                raise Fog::Compute::AWS::Error, "RouteAlreadyExists => The route identified by #{options['destinationCidrBlock']} doesn't exist."
              else
                response = Excon::Response.new
                route_set = route_table['routeSet'].find { |routeset| routeset['destinationCidrBlock'].eql? options['destinationCidrBlock'] }
                route_set.merge!(options)
                route_set['state'] = 'pending'
                route_set['origin'] = 'ReplaceRoute'

                response.status = 200
                response.body = {
                  'requestId'=> Fog::AWS::Mock.request_id,
                  'return' => true
                }
                response
              end
            else
              message = 'MissingParameter => '
              message << 'The request must contain either a gateway id, a network interface id, or an instance id'
              raise Fog::Compute::AWS::Error.new(message)
            end
          elsif route_table.nil?
            raise Fog::Compute::AWS::NotFound.new("The routeTable ID '#{route_table_id}' does not exist")
          elsif options['destinationCidrBlock'].empty?
            raise Fog::Compute::AWS::InvalidParameterValue.new("Value () for parameter destinationCidrBlock is invalid. This is not a valid CIDR block.")
          end
        end

        # def replace_route(route_table_id, destination_cidr_block, internet_gateway_id=nil, instance_id=nil, network_interface_id=nil)
        #   instance_owner_id = nil
        #   route_table = self.data[:route_tables].find { |routetable| routetable["routeTableId"].eql? route_table_id }
        #   if !route_table.nil? && destination_cidr_block
        #     if !internet_gateway_id.nil? || !instance_id.nil? || !network_interface_id.nil?
        #       if !internet_gateway_id.nil? && self.internet_gateways.all('internet-gateway-id'=>internet_gateway_id).first.nil?
        #         raise Fog::Compute::AWS::NotFound.new("The gateway ID '#{internet_gateway_id}' does not exist")
        #       elsif !instance_id.nil? && self.servers.all('instance-id'=>instance_id).first.nil?
        #         raise Fog::Compute::AWS::NotFound.new("The instance ID '#{instance_id}' does not exist")
        #       elsif !network_interface_id.nil? && self.network_interfaces.all('networkInterfaceId'=>network_interface_id).first.nil?
        #         raise Fog::Compute::AWS::NotFound.new("The networkInterface ID '#{network_interface_id}' does not exist")
        #       elsif route_table['routeSet'].find { |route| route['destinationCidrBlock'].eql? destination_cidr_block }.nil?
        #         raise Fog::Compute::AWS::Error, "RouteAlreadyExists => The route identified by #{destination_cidr_block} doesn't exist."
        #       else
        #         response = Excon::Response.new
        #         route_table['routeSet'].push({
        #           "destinationCidrBlock" => destination_cidr_block,
        #           "gatewayId" => internet_gateway_id,
        #           "instanceId"=>instance_id,
        #           "instanceOwnerId"=>instance_owner_id,
        #           "networkInterfaceId"=>network_interface_id,
        #           "state" => "pending",
        #           "origin" => "ReplaceRoute"
        #         })
        #         response.status = 200
        #         response.body = {
        #           'requestId'=> Fog::AWS::Mock.request_id,
        #           'return' => true
        #         }
        #         response
        #       end
        #     else
        #       message = 'MissingParameter => '
        #       message << 'The request must contain either a gateway id, a network interface id, or an instance id'
        #       raise Fog::Compute::AWS::Error.new(message)
        #     end
        #   elsif route_table.nil?
        #     raise Fog::Compute::AWS::NotFound.new("The routeTable ID '#{route_table_id}' does not exist")
        #   elsif destination_cidr_block.empty?
        #     raise Fog::Compute::AWS::InvalidParameterValue.new("Value () for parameter destinationCidrBlock is invalid. This is not a valid CIDR block.")
        #   end
        # end

      end
    end
  end
end
