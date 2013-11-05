require 'fog/core/collection'
require 'fog/vcloud_director/models/compute/edgegateway'

module Fog
  module Compute
    class VcloudDirector

      class Edgegateways < Collection
        model Fog::Compute::VcloudDirector::Edgegateway

        attribute :vdc
        
        private

        def get_by_id(item_id)
          puts item_id
          item = service.get_org_vdc_gateway(item_id).body
          service.add_id_from_href!(item)
          item
        end

        def item_list
          data = service.get_org_vdc_gateways(vdc.id).body
          
          items = data[:EdgeGatewayRecord].select
          items.each{|item| service.add_id_from_href!(item) }
          items
        end

      end
    end
  end
end
