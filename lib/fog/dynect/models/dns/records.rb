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
          service.get_all_records(zone.domain, options).body['data'].each do |url|
            (_, _, t, _, fqdn, id) = url.split('/')
            type = t.gsub(/Record$/, '')

            # leave out the default, read only records
            # by putting this here we don't make the secondary request for these records
            next if ['NS', 'SOA'].include?(type)

            record = service.get_record(type, zone.domain, fqdn, 'record_id' => id).body['data']

            data << {
              :identity => record['record_id'],
              :fqdn => record['fqdn'],
              :type => record['record_type'],
              :rdata => record['rdata']
            }
          end

          load(data)
        end

        def get(record_id)
          requires :zone

          list = service.get_all_records(zone.domain, {}).body['data']
          url = list.detect { |e| e =~ /\/#{record_id}$/ }
          return unless url
          (_, _, t, _, fqdn, id) = url.split('/')
          type = t.gsub(/Record$/, '')
          record = service.get_record(type, zone.domain, fqdn, 'record_id' => id).body['data']

          new({
            :identity => record['record_id'],
            :fqdn => record['fqdn'],
            :type => record['record_type'],
            :rdata => record['rdata']
          })
        end

        def new(attributes = {})
          requires :zone
          super({:zone => zone}.merge!(attributes))
        end

      end

    end
  end
end
