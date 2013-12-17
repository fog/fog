require 'fog/core/model'

module Fog
  module Compute
    class XenServer
      class Pgpu < Fog::Model
        # API Reference here:
        # http://docs.vmd.citrix.com/XenServer/6.2.0/1.0/en_gb/api/?c=PGPU

        identity :reference

        attribute :__gpu_group,         :aliases => :GPU_group
        attribute :__host,              :aliases => :host
        attribute :other_config
        attribute :__pci,               :aliases => :PCI
        attribute :uuid
      end
    end
  end
end
