require 'fog/core/collection'
require 'fog/storm_on_demand/models/dns/record'

module Fog
  module DNS
    class StormOnDemand

      class Records < Fog::Collection
        model Fog::DNS::StormOnDemand::Record

        def create(options)
          rec = service.create_record(options).body
          new(rec)
        end

        def get(record_id)
          rec = service.get_record(:id => record_id).body
          new(rec)
        end

        def all(options={})
          recs = service.list_records(options).body['items']
          load(recs)
        end

      end

    end
  end
end
