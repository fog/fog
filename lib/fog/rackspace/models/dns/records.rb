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

          left = 0
          records=[]
          begin
            data = connection.list_records(zone.identity, :offset=>records.count)
            records += data.body['records']
            left = data.body['totalEntries'] - records.count
          end while data.status==200 && left>0
          load(records)
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
