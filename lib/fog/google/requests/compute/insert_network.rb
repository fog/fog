module Fog
  module Compute
    class Google
      class Mock
        def insert_network(network_name, ip_range, options = {})
          Fog::Mock.not_implemented
        end
      end

      class Real
        def insert_network(network_name, ip_range, options = {})
          api_method = @compute.networks.insert
          parameters = {
            'project' => @project,
          }
          body_object = {
            'name' => network_name,
            'IPv4Range' => ip_range
          }

          body_object['description'] = options[:description] if options[:description]
          body_object['gatewayIPv4'] = options[:gateway_ipv4] if options[:gateway_ipv4]

          request(api_method, parameters, body_object)
        end
      end
    end
  end
end
