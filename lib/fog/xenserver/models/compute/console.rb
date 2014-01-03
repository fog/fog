require 'fog/core/model'

module Fog
  module Compute
    class XenServer
      class Console < Fog::Model
        # API Reference here:
        # http://docs.vmd.citrix.com/XenServer/6.2.0/1.0/en_gb/api/?c=console

        identity :reference

        attribute :location
        attribute :other_config
        attribute :protocol
        attribute :uuid
        attribute :__vm, aliases: :VM

        def vm
          begin
            vm = service.servers.get __vm
          rescue Fog::XenServer::RequestFailed => e
            vm = nil
          end
          vm
        end
      end
    end
  end
end
