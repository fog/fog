require 'fog/core/collection'
require 'fog/compute/models/linode/ip'

module Fog
  module Linode
    class Compute
      class Ips < Fog::Collection
        model Fog::Linode::Compute::Ip

        def all(linode_id)
          load ips(linode_id)
        end

        def get(linode_id, id)
          new ips(linode_id, id).first
        rescue Fog::Linode::Compute::NotFound
          nil
        end        

        private
        def ips(linode_id, id=nil)
          connection.linode_ip_list(linode_id, id).body['DATA'].map { |ip| map_ip ip }
        end
        
        def map_ip(ip)
          ip = ip.each_with_object({}) { |(k, v), h| h[k.downcase.to_sym] = v  }
          ip.merge! :id => ip[:ipaddressid], :ip => ip[:ipaddress], :public => ip[:ispublic]==1
        end
      end
    end
  end
end
