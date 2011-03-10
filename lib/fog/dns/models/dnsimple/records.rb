require 'fog/core/collection'
require 'fog/dns/models/dnsimple/record'

module Fog
  module DNSimple
    class DNS

      class Records < Fog::Collection

        attribute :zone

        model Fog::DNSimple::DNS::Record

        def all
          requires :zone
          clear
          data = connection.list_records(zone.id).body          
          data.each {|object| self << new(object["record"]) }
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
