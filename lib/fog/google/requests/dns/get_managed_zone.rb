module Fog
  module DNS
    class Google

      class Mock
        def get_managed_zone(zone_name_or_id)
	  if self.data[:managed_zones][:by_name].has_key?(zone_name_or_id)
            build_excon_response(self.data[:managed_zones][:by_name][zone_name_or_id])
	  elsif self.data[:managed_zones][:by_id].has_key?(zone_name_or_id)
            build_excon_response(self.data[:managed_zones][:by_id][zone_name_or_id])
	  else
	    raise Fog::Errors::NotFound, "The 'parameters.managedZone' resource named '#{zone_name_or_id}' does not exist."
	  end
        end

      end

      class Real
        def get_managed_zone(zone_name_or_id)
          api_method = @dns.managed_zones.get
          parameters = {
            'project' => @project,
	    'managedZone' => zone_name_or_id,
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
