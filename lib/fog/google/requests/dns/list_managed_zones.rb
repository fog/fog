module Fog
  module DNS
    class Google
      ##
      # Enumerates Managed Zones that have been created but not yet deleted.
      #
      # @see hhttps://developers.google.com/cloud-dns/api/v1beta1/managedZones/list
      class Real
        def list_managed_zones()
          api_method = @dns.managed_zones.list
          parameters = {
            'project' => @project,
          }

          request(api_method, parameters)
        end
      end

      class Mock
        def list_managed_zones()
          body = {
            'kind' => 'dns#managedZonesListResponse',
            'managedZones' => self.data[:managed_zones].values,
          }

          build_excon_response(body)
        end
      end
    end
  end
end
