require 'fog/core/collection'
require 'fog/hp/models/lb/virtual_ip'

module Fog
  module HP
    class LB
      class VirtualIps < Fog::Collection
        model Fog::HP::LB::VirtualIp

        def all
          data = service.list_load_balancer_virtual_ips(@attributes[:load_balancer_id]).body['virtualIps']
          load(data)
          self.each{ |x| x.load_balancer_id = @attributes[:load_balancer_id] }
        end

        def get(record_id)
          record = service.get_virtual_ip_details(record_id).body['virtual_ip']
          new(record)
        rescue Fog::HP::LB::NotFound
          nil
        end

      end
    end
  end
end
