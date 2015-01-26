require 'fog/core/model'

module Fog
  module Compute
    class XenServer
      class PifMetrics < Fog::Model
        # API Reference here:
        # http://docs.vmd.citrix.com/XenServer/6.2.0/1.0/en_gb/api/?c=PIF_metrics

        identity :reference

        attribute :carrier
        attribute :device_id
        attribute :device_name
        attribute :duplex
        attribute :io_read_kbs
        attribute :io_write_kbs
        attribute :last_updated
        attribute :other_config
        attribute :pci_bus_path
        attribute :speed
        attribute :uuid
        attribute :vendor_id
        attribute :vendor_name
      end
    end
  end
end
