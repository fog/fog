require 'fog/core/collection'
require 'fog/hp/models/lb/virtual_ip'

module Fog
  module HP
    class LB
      class VirtualIps < Fog::Collection
        model Fog::HP::LB::VirtualIp

        def all
          data = connection.list_virtual_ips.body['virtual_ips']
          load(data)
        end

        def get(record_id)
          record = connection.get_virtual_ip_details(record_id).body['virtual_ip']
          new(record)
        rescue Fog::HP::LB::NotFound
          nil
        end

      end
    end
  end
end