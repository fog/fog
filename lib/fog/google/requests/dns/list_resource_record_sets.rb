module Fog
  module DNS
    class Google
      ##
      # Enumerates Resource Record Sets that have been created but not yet deleted.
      #
      # @see https://developers.google.com/cloud-dns/api/v1beta1/resourceRecordSets/list
      class Real
        def list_resource_record_sets(zone_name_or_id)
          api_method = @dns.resource_record_sets.list
          parameters = {
            'project' => @project,
            'managedZone' => zone_name_or_id,
          }

          request(api_method, parameters)
        end
      end

      class Mock
        def list_resource_record_sets(zone_name_or_id)
          if self.data[:managed_zones].has_key?(zone_name_or_id)
            zone = self.data[:managed_zones][zone_name_or_id]
          else
            zone = self.data[:managed_zones].values.find { |zone| zone['name'] = zone_name_or_id }
          end

          unless zone
            raise Fog::Errors::NotFound, "The 'parameters.managedZone' resource named '#{zone_name_or_id}' does not exist."
          end

          body = {
            'kind' => 'dns#resourceRecordSetsListResponse',
            'rrsets' => self.data[:resource_record_sets][zone['id']],
          }
          build_excon_response(body)
        end
      end
    end
  end
end
