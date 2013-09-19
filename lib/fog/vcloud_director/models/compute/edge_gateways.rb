require 'fog/core/collection'
require 'fog/vcloud_director/models/compute/edge_gateway'

module Fog
  module Compute
    class VcloudDirector

      class EdgeGateways < Collection
        model Fog::Compute::VcloudDirector::EdgeGateway

        attribute :vdc

        private

        def get_by_id(item_id)
          item = service.get_edge_gateway(item_id).body
          service.add_id_from_href!(item)
          item
        end

        def item_list
          data = service.get_edge_gateways(vdc.id).body
          edge_gateways = data[:EdgeGatewayRecord].is_a?(Hash) ? [data[:EdgeGatewayRecord]] : data[:EdgeGatewayRecord]
          edge_gateways.each {|edgeGateway| service.add_id_from_href!(edgeGateway)}
        end

      end
    end
  end
end
