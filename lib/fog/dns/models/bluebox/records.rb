require 'fog/core/collection'
require 'fog/dns/models/bluebox/record'

module Fog
  module Bluebox
    class DNS

      class Records < Fog::Collection

        attribute :zone

        model Fog::Bluebox::DNS::Record

        def all
          requires :zone
          data = connection.get_records(zone.identity).body['records']
          load(data)
        end

        def get(record_id)
          data = connection.get_record(zone.identity, record_id).body
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
