require 'fog/core/collection'
require 'fog/xenserver/models/compute/tunnel'

module Fog
  module Compute
    class XenServer
      class Tunnels < Fog::Collection
        model Fog::Compute::XenServer::Tunnel

        def all(options={})
          data = service.get_records 'tunnel'
          load(data)
        end

        def get( tunnel_ref )
          if tunnel_ref && tunnel = service.get_record( tunnel_ref, 'tunnel' )
            new(tunnel)
          else
            nil
          end
        end
      end
    end
  end
end
