require 'fog/core/collection'
require 'fog/dns/models/dynect/record'

module Fog
  module Dynect
    class DNS

      class Records < Fog::Collection

        attribute :zone

        model Fog::Dynect::DNS::Record

        def all(attributes={})
          selected_nodes = nodes
          selected_nodes = nodes.select do |node|
            Array(attributes[:nodes]).include?(node)
          end if attributes[:nodes]

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
