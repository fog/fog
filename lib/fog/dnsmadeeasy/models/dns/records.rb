require 'fog/core/collection'
require 'fog/dnsmadeeasy/models/dns/record'

module Fog
  module DNS
    class DNSMadeEasy

      class Records < Fog::Collection

        attribute :zone

        model Fog::DNS::DNSMadeEasy::Record

        def all
          requires :zone
          data = connection.list_records(zone.identity).body
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
