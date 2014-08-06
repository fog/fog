module Fog
  module Compute
    class Google
      class Mock
        def list_aggregated_disks(options = {})
          # Create a Hash of unique zones from the disks Array previously filled when disks are created
          zones = Hash[self.data[:disks].values.map { |disk| ["zones/#{disk['zone'].split('/')[-1]}", {'disks' => [] }] }]
          if options[:filter]
            # Look up for the disk name
            disk = self.data[:disks][options[:filter].gsub(/name eq \.\*/, '')]
            # Fill the zones Hash with the disk (if it's found)
            zones["zones/#{disk['zone'].split('/')[-1]}"]['disks'].concat([disk]) if disk
          else
            # Fill the zones Hash with the disks attached to each zone
            self.data[:disks].values.each { |disk| zones["zones/#{disk['zone'].split('/')[-1]}"]['disks'].concat([disk]) }
          end
          build_excon_response({
            "kind" => "compute#diskAggregatedList",
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/aggregated/disks",
            "id" => "projects/#{@project}/aggregated/disks",
            "items" => zones

          })
        end
      end

      class Real
        def list_aggregated_disks(options = {})
          api_method = @compute.disks.aggregated_list
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
