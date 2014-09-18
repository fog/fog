require 'fog/core/collection'
require 'fog/google/models/dns/record'

module Fog
  module DNS
    class Google
      class Records < Fog::Collection
        model Fog::DNS::Google::Record

        attribute :zone

        ##
        # Enumerates Resource Record Sets that have been created but not yet deleted
        #
        # @return [Array<Fog::DNS::Google::Record>] List of Resource Record Sets resources
        def all
          requires :zone

          data = service.list_resource_record_sets(zone.identity).body['rrsets'] || []
          load(data)
        rescue Fog::Errors::NotFound
          []
        end
      end
    end
  end
end
