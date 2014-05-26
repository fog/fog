require 'fog/core/collection'
require 'fog/zerigo/models/dns/record'

module Fog
  module DNS
    class Zerigo
      class Records < Fog::Collection
        attribute :zone

        model Fog::DNS::Zerigo::Record

        # List all domains
        # @param [Hash] options Options to pass to the underlying API call
        # @option options [String] :fqdn search for the given fqdn
        def all(options = {})
          requires :zone
          if options[:fqdn]
            hosts = service.find_hosts(options[:fqdn], zone.id).body['hosts']
            load(hosts)
          else
            parent = zone.collection.get(zone.identity)
            if parent
              merge_attributes(parent.records.attributes)
              load(parent.records.map {|record| record.attributes})
            else
              nil
            end
          end
        end

        def get(record_id)
          data = service.get_host(record_id).body
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
