require 'fog/core/collection'
require 'fog/dynect/models/dns/record'

module Fog
  module DNS
    class Dynect
      class Records < Fog::Collection
        attribute :zone

        model Fog::DNS::Dynect::Record

        def all(options = {})
          requires :zone
          data = []
          service.get_all_records(zone.domain, options).body['data'].each do |records|
            (type, list) = records
            next if %w{soa_records ns_records}.include?(type)
            list.each do |record|
              data << {
                :identity => record['record_id'],
                :fqdn => record['fqdn'],
                :type => record['record_type'],
                :rdata => record['rdata']
              }
            end
          end

          load(data)
        end

        def get(record_id)
          requires :zone

          # there isn't a way to look up by just id
          # must have type and domain for 'get_record' request
          # so we pick it from the list returned by 'all'

          list = all
          list.detect {|e| e.id == record_id}
        end

        def new(attributes = {})
          requires :zone
          super({:zone => zone}.merge!(attributes))
        end
      end
    end
  end
end
