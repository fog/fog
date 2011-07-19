require 'fog/core/collection'
require 'fog/rackspace/models/virtual_ip'

module Fog
  module Rackspace
    class LoadBalancer
      class VirtualIps < Fog::Collection
        model Fog::Rackspace::LoadBalancer::VirtualIp

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

        def to_object
          collect do |node|
            node.to_object
          end
        end

        private
        def all_raw
          connection.list_virtual_ips(load_balancer.id).body['virtualIps']
        end
      end
    end
  end
end
