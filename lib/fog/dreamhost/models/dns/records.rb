require 'fog/core/collection'
require 'fog/dreamhost/models/dns/record'

module Fog
  module DNS
    class Dreamhost
      class Records < Fog::Collection
        model Fog::DNS::Dreamhost::Record

        def all(filter = {})
          clear
          if filter[:zone]
            data = service.list_records.body['data'].select { |r| r['zone'] == filter[:zone] }
          else
            data = service.list_records.body['data']
          end
          load(data)
        end

        def get(record_name)
          data = service.list_records.body['data'].find { |r| r['record'] == record_name }
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end
      end

      def new(attributes = {})
        requires :zone
        super({ :zone => zone }.merge!(attributes))
      end
    end
  end
end
