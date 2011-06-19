require 'fog/core/collection'
require 'fog/dns/models/dynect/record'

module Fog
  module Dynect
    class DNS

      class Records < Fog::Collection

        attribute :zone

        model Fog::Dynect::DNS::Record

        def all(filter=nil)
          selected_nodes = nodes
          selected_nodes = nodes.select do |node|
            node =~ /#{Regexp.escape(filter)}$/
          end if filter

          data = selected_nodes.inject([]) do |m, node|
            m += connection.list_any_records(zone.id, node).map(&:body)
            m
          end

          load(data)
        end

        def get(record_id)
        end

        def new(attributes = {})
          requires :zone
          super({ :zone => zone }.merge!(attributes))
        end

        private

        def nodes
          requires :zone
          Array(connection.node_list(zone.id).body)
        end

      end

    end
  end
end
