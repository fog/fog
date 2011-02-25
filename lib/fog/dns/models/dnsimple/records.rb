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
          data = connection.list_records(zone.id).body
        end

        def get(record_id)
          all.each do |record|
            if record["record"]["id"] == record_id
              return new(record)
            end
          end

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
