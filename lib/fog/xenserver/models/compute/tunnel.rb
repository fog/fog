require 'fog/core/model'

module Fog
  module Compute
    class XenServer
      class Tunnel < Fog::Model
        # API Reference here:
        # http://docs.vmd.citrix.com/XenServer/6.2.0/1.0/en_gb/api/?c=tunnel

        identity :reference

        attribute :access_pif,          :aliases => :access_PIF
        attribute :other_config
        attribute :status
        attribute :transport_pif,       :aliases => :transport_PIF
        attribute :uuid
      end
    end
  end
end
