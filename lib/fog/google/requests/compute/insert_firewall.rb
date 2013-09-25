module Fog
  module Compute
    class Google

      class Mock

        def insert_firewall(firewall_name)
          Fog::Mock.not_implemented
        end

      end

      class Real

        def insert_firewall(firewall_name, source_range, allowed,
                            network=@default_network)
          api_method = @compute.firewalls.insert
          parameters = {
            'project' => @project,
          }
          body_object = {
            "name" => firewall_name,
            "network" => "#{@api_url}#{@project}/global/networks/#{network}",
            "sourceRanges" => source_range,
            "allowed" => allowed
          }

          result = self.build_result(api_method, parameters,
                                     body_object=body_object)
          response = self.build_response(result)
        end

      end

    end
  end
end
