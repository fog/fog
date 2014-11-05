module Fog
  module DNS
    class Google
      ##
      # Fetches the representation of an existing Managed Zone.
      #
      # @see https://developers.google.com/cloud-dns/api/v1beta1/managedZones/get
      class Real
        def get_managed_zone(name_or_id)
          api_method = @dns.managed_zones.get
          parameters = {
            'project' => @project,
            'managedZone' => name_or_id,
          }

          request(api_method, parameters)
        end
      end

      class Mock
        def get_managed_zone(name_or_id)
          if self.data[:managed_zones].has_key?(name_or_id)
            data = self.data[:managed_zones][name_or_id]
          else
            data = self.data[:managed_zones].values.find { |zone| zone['name'] = name_or_id }
          end

          unless data
            raise Fog::Errors::NotFound, "The 'parameters.managedZone' resource named '#{name_or_id}' does not exist."
          end

          build_excon_response(data)
        end
      end
    end
  end
end
