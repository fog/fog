require 'fog/core/collection'
require 'fog/slicehost/models/dns/record'

module Fog
  module DNS
    class Slicehost

      class Records < Fog::Collection

        attribute :zone

        model Fog::DNS::Slicehost::Record

        def all
          requires :zone
          data = connection.get_records.body['records']
          load(data).reject {|record| record.zone_id != zone.id}
        end

        def get(record_id)
          data = connection.get_record(record_id).body
          new(data)
        rescue Excon::Errors::Forbidden
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
