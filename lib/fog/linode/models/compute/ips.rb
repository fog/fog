require 'fog/core/collection'
require 'fog/linode/models/compute/ip'

module Fog
  module Compute
    class Linode
      class Ips < Fog::Collection
        model Fog::Compute::Linode::Ip
        attribute :server

        def all
          requires :server
          load ips(server.id)
        end

        def get(id)
          requires :server
          new ips(server.id, id).first
        rescue Fog::Compute::Linode::NotFound
          nil
        end

        def new(attributes = {})
          requires :server
          super({ :server => server }.merge!(attributes))
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
