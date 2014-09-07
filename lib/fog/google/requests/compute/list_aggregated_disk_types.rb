module Fog
  module Compute
    class Google
      class Mock
        def list_aggregated_disk_types(options = {})
          disk_types_items = {}
          if options[:filter]
            disk_type = options[:filter].gsub(/name eq \.\*/, '')
            self.data[:zones].keys.each do |zone|
              disk_types = list_disk_types(zone).body['items'].select { |dt| dt['name'] == disk_type } || []
              disk_types_items["zones/#{zone}"] = { 'diskTypes' => disk_types } unless disk_types.empty?
            end
          else
            self.data[:zones].keys.each do |zone|
              disk_types = list_disk_types(zone).body['items']
              disk_types_items["zones/#{zone}"] = { 'diskTypes' => disk_types }
            end
          end
          build_excon_response({
            'kind' => 'compute#diskTypeAggregatedList',
            'selfLink' => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/aggregated/diskTypes",
            'items' => disk_types_items,
          })
        end
      end

      class Real
        def list_aggregated_disk_types(options = {})
          api_method = @compute.disk_types.aggregated_list
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
