module Fog
  module DNS
    class Google
      ##
      # Enumerates the list of Changes.
      #
      # @see https://developers.google.com/cloud-dns/api/v1beta1/changes/list
      class Real
        def list_changes(zone_name_or_id)
          api_method = @dns.changes.list
          parameters = {
            'project' => @project,
            'managedZone' => zone_name_or_id,
          }

          request(api_method, parameters)
        end
      end

      class Mock
        def list_changes(zone_name_or_id)
          if self.data[:managed_zones].has_key?(zone_name_or_id)
            zone = self.data[:managed_zones][zone_name_or_id]
          else
            zone = self.data[:managed_zones].values.find { |zone| zone['name'] == zone_name_or_id }
          end

          unless zone
            raise Fog::Errors::NotFound, "The 'parameters.managedZone' resource named '#{zone_name_or_id}' does not exist."
          end

          body = {
            'kind' => 'dns#changesListResponse',
            'changes' => self.data[:changes][zone['id']],
          }
          build_excon_response(body)
        end
      end
    end
  end
end
