require 'fog/core/collection'
require 'fog/google/models/dns/zone'

module Fog
  module DNS
    class Google
      class Changes < Fog::Collection
        model Fog::DNS::Google::Change

        attribute :zone

        ##
        # Enumerates the list of Changes
        #
        # @return [Array<Fog::DNS::Google::Change>] List of Changes resources
        def all
          requires :zone

          data = service.list_changes(zone.identity).body['changes'] || []
          load(data)
        rescue Fog::Errors::NotFound
          []
        end

        ##
        # Fetches the representation of an existing Change
        #
        # @param [String] identity Change identity
        # @return [Fog::DNS::Google::Change] Change resource
        def get(identity)
          requires :zone

          if change = service.get_change(zone.identity, identity).body
            new(change)
          end
        rescue Fog::Errors::NotFound
          nil
        end

        ##
        # Creates a new instance of a Change
        #
        # @return [Fog::DNS::Google::Change] Change resource
        def new(attributes = {})
          requires :zone

          super({ :zone => zone }.merge!(attributes))
        end
      end
    end
  end
end
