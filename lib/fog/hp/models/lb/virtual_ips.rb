require 'fog/core/collection'
require 'fog/hp/models/lb/virtual_ip'

module Fog
  module HP
    class LB
      class VirtualIps < Fog::Collection
        model Fog::HP::LB::VirtualIp

        attr_accessor :load_balancer

        def all
          requires :load_balancer

          data = service.list_load_balancer_virtual_ips(load_balancer.id).body['virtualIps']
          load(data)
        end

        def get(vip_id)
          requires :load_balancer

          data = service.list_load_balancer_virtual_ips(load_balancer.id).body['virtualIps']
          vip = data.find {|vip| vip['id'].to_s == vip_id}
          new(vip)
        rescue Fog::HP::LB::NotFound
          nil
        end
      end
    end
  end
end
