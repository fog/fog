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
          connection.get_node_list(zone.domain, options).body['data'].each do |fqdn|
            records = connection.get_record('ANY', zone.domain, fqdn).body['data']

            # data in format ['/REST/xRecord/domain/fqdn/identity]
            records.map! do |record|
              tokens = record.split('/')
              {
                :identity => tokens.last,
                :fqdn     => fqdn,
                :type     => tokens[2][0...-6] # everything before 'Record'
              }
            end

            data.concat(records)
          end

          # leave out the default, read only records
          data = data.reject {|record| ['NS', 'SOA'].include?(record[:type])}

          load(data)
        end

        def get(record_id)
          # FIXME: can this be done more efficiently?
          all.detect {|record| record.identity == record_id}
        end

        def new(attributes = {})
          requires :zone
          super({ :zone => zone }.merge!(attributes))
        end

      end

    end
  end
end
