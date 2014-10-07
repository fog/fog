module Fog
  module Compute
    class Google
      class Mock
        def insert_route(name, network, dest_range, priority, options = {})
          Fog::Mock.not_implemented
        end
      end

      class Real
        def insert_route(name, network, dest_range, priority, options = {})
          api_method = @compute.routes.insert
          parameters = {
            'project' => @project,
          }
          body_object = {
            'name' => name,
            'network' => network,
            'destRange' => dest_range,
            'priority' => priority,
          }
          body_object['description'] = options[:description] if options[:description]
          unless options[:tags].nil? || options[:tags].empty?
            body_object['tags'] = options[:tags]
          end
          body_object['nextHopInstance'] = options[:next_hop_instance] if options[:next_hop_instance]
          body_object['nextHopGateway'] = options[:next_hop_gateway] if options[:next_hop_gateway]
          body_object['nextHopIp'] = options[:next_hop_ip] if options[:next_hop_ip]

          request(api_method, parameters, body_object)
        end
      end
    end
  end
end
