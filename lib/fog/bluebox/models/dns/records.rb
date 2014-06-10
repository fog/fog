require 'fog/core/collection'
require 'fog/bluebox/models/dns/record'

module Fog
  module DNS
    class Bluebox
      class Records < Fog::Collection
        attribute :zone

        model Fog::DNS::Bluebox::Record

        def all
          requires :zone
          data = service.get_records(zone.identity).body['records']
          load(data)
        end

        def get(record_id)
          data = service.get_record(zone.identity, record_id).body
          new(data)
        rescue Fog::Service::NotFound
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
