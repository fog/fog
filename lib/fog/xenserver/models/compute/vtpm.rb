require 'fog/core/model'

module Fog
  module Compute
    class XenServer
      class Vtpm < Fog::Model
        # API Reference here:
        # http://docs.vmd.citrix.com/XenServer/6.2.0/1.0/en_gb/api/?c=VTPM

        identity :reference

        attribute :__backend,       :aliases => :backend
        attribute :uuid
        attribute :__vm,            :aliases => :vm
      end
    end
  end
end
