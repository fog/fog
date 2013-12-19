require 'fog/core/model'

module Fog
  module Compute
    class XenServer
      class HostCrashDump < Fog::Model
        # API Reference here:
        # http://docs.vmd.citrix.com/XenServer/6.2.0/1.0/en_gb/api/?c=host_crashdump

        identity :reference

        attribute :__host,              :aliases => :host
        attribute :other_config
        attribute :size
        attribute :timestamp
        attribute :uuid
      end
    end
  end
end
