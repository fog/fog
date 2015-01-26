require 'fog/core/collection'
require 'fog/hp/models/dns/record'

module Fog
  module HP
    class DNS
      class Records < Fog::Collection
        model Fog::HP::DNS::Record

        attr_accessor :domain

        def all
          requires :domain
          load(service.list_records_in_a_domain(domain.id).body['records'])
        end

        def get(record_id)
          requires :domain
          ### Inconsistent API - does not return a 'record'
          if record = service.get_record(domain.id, record_id).body
            new(record)
          end
        rescue Fog::HP::DNS::NotFound
          nil
        end
      end
    end
  end
end
