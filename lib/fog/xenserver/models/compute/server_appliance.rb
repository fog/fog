require 'fog/core/model'

module Fog
  module Compute
    class XenServer
      class ServerAppliance < Fog::Model
        # API Reference here:
        # http://docs.vmd.citrix.com/XenServer/6.2.0/1.0/en_gb/api/?c=VM_appliance

        identity :reference

        attribute :allowed_operations
        attribute :current_operations
        attribute :description,             :aliases => :name_description
        attribute :name,                    :aliases => :name_label
        attribute :uuid
        attribute :__vms,                   :aliases => :VMs
      end
    end
  end
end
