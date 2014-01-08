module Fog
  module Compute
    class Google
      module RequestsHelper

        def get_zone_name(zone_name_or_url)
          if zone_name_or_url.match(/^https?:\/\//)
            index = zone_name_or_url.rindex('/')
            index.nil? ? zone_name_or_url : zone_name_or_url[(index + 1)..-1]            
          else
            zone_name_or_url
          end
        end

        def get_zone_url(zone_name_or_url)
          if zone_name_or_url.match(/^https?:\/\//)
            zone_name_or_url
          else
            "https://www.googleapis.com/compute/v1/projects/#{@project}/zones/#{zone_name_or_url}"
          end
        end

      end

    end

end

Fog::Compute::Google::Mock.send(:include, Fog::Compute::Google::RequestsHelper)
Fog::Compute::Google::Real.send(:include, Fog::Compute::Google::RequestsHelper)