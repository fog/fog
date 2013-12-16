require 'fog/core/model'

module Fog
  module Compute
    class XenServer
      class DrTask < Fog::Model
        # API Reference here:
        # http://docs.vmd.citrix.com/XenServer/6.2.0/1.0/en_gb/api/?c=DR_task

        identity :reference

        attribute :__introduced_srs,        :aliases => :introduced_SRs
        attribute :uuid
      end
    end
  end
end
