module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/assign_private_ip_addresses'

        # Assigns one or more secondary private IP addresses to the specified network interface.
        #
        # ==== Parameters
        # * network_interface_id<~String> - The ID of the network interface
        # * private_ip_address<~String> - One or more IP addresses to be assigned as a secondary private IP address (conditional)
        # * secondary_private_ip_address_count<~String> - The number of secondary IP addresses to assign (conditional)
        # * allow_reassignment<~Boolean> - Whether to reassign an IP address
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - The ID of the request.
        #     * 'return'<~Boolean> - success?
        #
        # {Amazon API Reference}[http://docs.aws.amazon.com/AWSEC2/latest/APIReference/ApiReference-query-AssignPrivateIpAddresses.html]
        def assign_private_ip_addresses(network_interface_id, private_ip_address=nil, secondary_private_ip_address_count=nil, allow_reassignment=false)
          domain = domain == 'vpc' ? 'vpc' : 'standard'
          request(
            'Action'  => 'AssignPrivateIpAddresses',
            'NetworkInterfaceId' => network_interface_id,
            'PrivateIpAddress.0' => private_ip_address,
            'SecondaryPrivateIpAddressCount' => secondary_private_ip_address_count,
            'AllowReassignment' => allow_reassignment,
            :parser   => Fog::Parsers::Compute::AWS::AssignPrivateIpAddresses.new
          )
        end

      end

      class Mock

        def assign_private_ip_addresses(network_interface_id, private_ip_address=nil, secondary_private_ip_address_count=nil, allow_reassignment=false)
          response = Excon::Response.new

          if (private_ip_address && !secondary_private_ip_address_count) || (!private_ip_address && secondary_private_ip_address_count)
            response.status = 200
            response.body = {
              'requestId' => Fog::AWS::Mock.request_id,
              'return' => true
            }
            response
          else
            raise Fog::Compute::AWS::Error.new("You cannot specify .")
          end
        end

      end
    end
  end
end
