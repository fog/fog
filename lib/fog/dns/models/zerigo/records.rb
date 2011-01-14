require 'fog/core/collection'
require 'fog/dns/models/zerigo/record'

module Fog
  module Zerigo
    class DNS

      class Records < Fog::Collection

        attribute :zone

        model Fog::Zerigo::DNS::Record

        def all
          requires :zone
          parent = zone.collection.get(zone.identity)
          if parent
            merge_attributes(parent.records.attributes)
            load(parent.records.map {|record| record.attributes})
          else
            nil
          end
        end

        def get(record_id)
          data = connection.get_host(record_id).body
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
