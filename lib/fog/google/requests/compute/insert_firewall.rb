module Fog
  module Compute
    class Google

      class Mock
        def insert_firewall(firewall_name, source_range=[],  allowed=[], network=@default_network, source_tags=[])
          Fog::Mock.not_implemented
        end

      end

      class Real

        def insert_firewall(firewall_name, source_range=[],  allowed=[], network=@default_network, source_tags=[])
          api_method = @compute.firewalls.insert
          parameters = {
            'project' => @project,
          }
          body_object = {
            "name" => firewall_name,
            "network" => "#{@api_url}#{@project}/global/networks/#{network}",
            "allowed" => allowed,
          }
          body_object["sourceRanges"] = source_range if !source_range.empty?
          body_object["sourceTags"]  = source_tags  if !source_tags.empty?

          result = self.build_result(api_method, parameters, body_object=body_object)
          response = self.build_response(result)
        end

      end

    end
  end
end
