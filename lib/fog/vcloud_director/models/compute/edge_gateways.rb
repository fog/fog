require 'fog/core/collection'

module Fog
  module Compute
    class VcloudDirector
      class EdgeGateways < Collection

        model Fog::Compute::VcloudDirector::EdgeGateway

        attribute :vdc

        private

        def get_by_id(item_id)
          item = service.get_edge_gateway(item_id).body
          item[:configuration] = item[:Configuration]
          %w(:Link :Entity :Configuration).each {|key_to_delete| item.delete(key_to_delete) }
          service.add_id_from_href!(item)
          item
        end

        def item_list
          filter = {:filter => "vdc==#{vdc.href}"}
          data = service.get_execute_query('edgeGateway', filter).body

          if data[:total].to_i > 1 then
            items = data[:EdgeGatewayRecord].select
            items.each{|item| service.add_id_from_href!(item)}
          elsif data[:total].to_i == 1 then
            items = []
            items[0] = data[:EdgeGatewayRecord]
            service.add_id_from_href!(items[0])
          else
            items = {}
          end

          items

        end
      end
    end
  end
end
