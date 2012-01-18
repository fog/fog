require 'fog/core/collection'
require 'fog/zerigo/models/dns/record'

module Fog
  module DNS
    class Zerigo

      class Records < Fog::Collection

        attribute :zone

        model Fog::DNS::Zerigo::Record

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

        def find(fqdn)
          hosts = connection.find_hosts(fqdn, zone.id).body['hosts']
          hosts.collect { |host| new(host) }
        end

      end

    end
  end
end
