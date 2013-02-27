require 'fog/core/collection'
require 'fog/hp/models/dns/record'

module Fog
  module HP
    class DNS
      class Records < Fog::Collection
        model Fog::HP::DNS : Record

        def all
          data = connection.list_records.body['records']
          load(data)
        end

        def get(record_id)
          record = connection.get_record_details(record_id).body['record']
          new(flavor)
        rescue Fog::HP::DNS::NotFound
          nil
        end

      end
    end
  end
end

