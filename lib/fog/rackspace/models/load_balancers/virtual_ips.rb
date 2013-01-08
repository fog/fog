require 'fog/core/collection'
require 'fog/rackspace/models/load_balancers/virtual_ip'

module Fog
  module Rackspace
    class LoadBalancers
      class VirtualIps < Fog::Collection
        model Fog::Rackspace::LoadBalancers::VirtualIp

        attr_accessor :load_balancer

        def all
          data = all_raw
          load(data)
        end

        #HACK - This method is somewhat hacky since there isn't a way to retrieve a single virtual IP.  Hopefully long term a method will
        # be added that allows a single virtual IP to be returned
        def get(virtual_ip_id)
          data = all_raw.select { |virtual_ip| virtual_ip['id'] == virtual_ip_id }.first
          data && new(data)
        end

        private
        def all_raw
          requires :load_balancer
          service.list_virtual_ips(load_balancer.id).body['virtualIps']
        end
      end
    end
  end
end
