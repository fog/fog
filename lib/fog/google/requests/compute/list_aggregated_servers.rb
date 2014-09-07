module Fog
  module Compute
    class Google
      class Mock
        def list_aggregated_servers(options = {})
          # Create a Hash of unique zones from the servers Array previously filled when servers are created
          zones = Hash[self.data[:servers].values.map { |server| ["zones/#{server['zone'].split('/')[-1]}", {'instances' => [] }] }]
          if options[:filter]
            # Look up for the server name
            server = self.data[:servers][options[:filter].gsub(/name eq \.\*/, '')]
            # Fill the zones Hash with the server (if it's found)
            zones["zones/#{server['zone'].split('/')[-1]}"]['instances'].concat([server]) if server
          else
            # Fill the zones Hash with the servers attached to each zone
            self.data[:servers].values.each { |server| zones["zones/#{server['zone'].split('/')[-1]}"]['instances'].concat([server]) }
          end
          build_excon_response({
            "kind" => "compute#instanceAggregatedList",
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/aggregated/instances",
            "id" => "projects/#{@project}/aggregated/instances",
            "items" => zones

          })
        end
      end

      class Real
        def list_aggregated_servers(options = {})
          api_method = @compute.instances.aggregated_list
          parameters = {
            'project' => @project,
          }
          parameters['filter'] = options[:filter] if options[:filter]

          request(api_method, parameters)
        end
      end
    end
  end
end
