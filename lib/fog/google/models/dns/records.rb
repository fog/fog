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

        ##
        # Creates a new instance of a Resource Record Set
        #
        # @return [Fog::DNS::Google::Record] Resource Record Set resource
        def new(attributes = {})
          requires :zone

          super({ :zone => zone }.merge!(attributes))
        end
      end
    end
  end
end
