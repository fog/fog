module Fog
  module DNS
    class Google
      class Mock
        def list_managed_zones()
          zones = self.data[:managed_zones][:by_id].values
          build_excon_response({
	    "kind" => "dns#managedZonesListResponse",
	    "managedZones" => zones,
          })
        end
      end

      class Real
        def list_managed_zones()
          api_method = @dns.managed_zones.list
          parameters = {
            'project' => @project,
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
