module Fog
  module Compute
    class Google
      module RequestsHelper

        def get_zone_name(zone_name_or_url)
          get_name(zone_name_or_url)
        end

        def get_zone_url(zone_name_or_url)
          build_url(zone_name_or_url) { |zone_name| "#{url_prefix}/zones/#{zone_name}" }
        end

        def get_machine_type_url(machine_type_name_or_url)
          build_url(zone_name_or_url) { |machine_type_name| "#{url_prefix}/zones/#{zone_name}/machineTypes/#{machine_type_name}" }
        end

        def instance_request_parameters(instance_name, zone_name_or_url)
          {
            'project'  => @project,
            'zone'     => get_zone_name(zone_name_or_url),
            'instance' => instance_name
          }
        end

        def disk_request_parameters(disk_name, zone_name_or_url)
          {
            'project' => @project,
            'zone'    => get_zone_name(zone_name_or_url),
            'disk'    => disk_name
          }
        end

        def zone_request_parameters(zone_name_or_url)
          {
            'project' => @project,
            'zone'    => get_zone_name(zone_name_or_url),
          }
        end        

      private 

        def is_url?(string)
          !!string.match(/^https?:\/\//)
        end

        def get_name(name_or_url)
          if is_url?(name_or_url)
            index = name_or_url.rindex('/')
            index.nil? ? name_or_url : name_or_url[(index + 1)..-1]            
          else
            name_or_url
          end          
        end

        def build_url(name_or_url, &block)
          is_url?(name_or_url) ? name_or_url : block.call(name_or_url)
        end

        def url_prefix
          "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}"
        end      

      end

      class Mock
        include Fog::Compute::Google::RequestsHelper
      end

      class Real
        include Fog::Compute::Google::RequestsHelper
      end

    end
  end
end
