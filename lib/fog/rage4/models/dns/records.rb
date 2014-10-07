require 'fog/core/collection'
require 'fog/rage4/models/dns/record'

module Fog
  module DNS
    class Rage4
      class Records < Fog::Collection
        attribute :zone

        model Fog::DNS::Rage4::Record

        def all
          requires :zone
          clear
          data = service.list_records(zone.id).body
          load(data)
        end

        def get(record_id)
          requires :zone
          data = service.list_records(zone.id).select {|record| record['id'] == record_id }
          if !data.empty?
            new(data.first)
          else
            nil
          end
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
