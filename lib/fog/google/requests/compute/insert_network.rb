module Fog
  module Compute
    class Google

      class Mock

        def insert_network(network_name, ip_range)
          Fog::Mock.not_implemented
        end

      end

      class Real

        def insert_network(network_name, ip_range)
          api_method = @compute.networks.insert
          parameters = {
            'project' => @project,
          }
          body_object = {
            'name' => network_name,
            'IPv4Range' => ip_range
          }

          result = self.build_result(api_method, parameters,
                                     body_object=body_object)
          response = self.build_response(result)
        end

      end

    end
  end
end
