require 'fog/core/collection'
require 'fog/dnsimple/models/dns/record'

module Fog
  module DNS
    class DNSimple

      class Records < Fog::Collection

        attribute :zone

        model Fog::DNS::DNSimple::Record

        def all
          requires :zone
          clear
          data = connection.list_records(zone.id).body.map {|record| record['record']}
          load(data)
        end

        def get(record_id)
          requires :zone
          data = connection.get_record(zone.id, record_id).body["record"]
          new(data)
        rescue Excon::Errors::NotFound
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
