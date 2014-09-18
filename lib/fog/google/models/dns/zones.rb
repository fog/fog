require 'fog/core/collection'
require 'fog/google/models/dns/zone'

module Fog
  module DNS
    class Google
      class Zones < Fog::Collection
        model Fog::DNS::Google::Zone

        ##
        # Enumerates Managed Zones that have been created but not yet deleted
        #
        # @return [Array<Fog::DNS::Google::Zone>] List of Managed Zone resources
        def all
          data = service.list_managed_zones.body['managedZones'] || []
          load(data)
        end

        ##
        # Fetches the representation of an existing Managed Zone
        #
        # @param [String] name_or_id Managed Zone name or identity
        # @return [Fog::DNS::Google::Zone] Managed Zone resource
        def get(name_or_id)
          if zone = service.get_managed_zone(name_or_id).body
            new(zone)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
