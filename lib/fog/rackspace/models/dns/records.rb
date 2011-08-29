require 'fog/core/collection'
require 'fog/rackspace/models/dns/record'

module Fog
  module DNS
    class Rackspace

      class Records < Fog::Collection

        attribute :zone

        model Fog::DNS::Rackspace::Record

        def all
          requires :zone
          data = connection.list_records(zone.identity)
          load(data.body['records'])
        end

        def get(record_id)
          requires :zone
          data = connection.list_record_details(zone.identity, record_id).body
          new(data)
        #nil or empty string will trigger an argument error
        rescue ArgumentError
          nil
        rescue Fog::Rackspace::Errors::NotFound
          nil
        end

        def new(attributes = {})
          requires :zone
          super({ :zone => zone }.merge!(attributes))
        end
      end
    end
  end
end
