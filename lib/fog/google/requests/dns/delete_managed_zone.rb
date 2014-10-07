module Fog
  module DNS
    class Google

      class Mock
        def delete_managed_zone(zone_name_or_id)
	  if self.data[:managed_zones][:by_name].has_key?(zone_name_or_id)
            zone_name = zone_name_or_id
            zone = self.data[:managed_zones][:by_name][zone_name]
	    zone_id = zone['id']
	  elsif self.data[:managed_zones][:by_id].has_key?(zone_name_or_id)
            zone_id = zone_name_or_id
            zone = self.data[:managed_zones][:by_name][zone_id]
	    zone_name = zone['name']
	  else
	    raise Fog::Errors::NotFound, "The 'parameters.managedZone' resource named '#{zone_name_or_id}' does not exist."
	  end
	  self.data[:managed_zones][:by_name].delete(zone_name)
	  self.data[:managed_zones][:by_id].delete(zone_id)

          build_excon_response(nil)
        end

      end

      class Real
        def delete_managed_zone(zone_name_or_id)
          api_method = @dns.managed_zones.delete
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
