require 'fog/core/model'

module Fog
  module Compute
    class XenServer
      class GpuGroup < Fog::Model
        # API Reference here:
        # http://docs.vmd.citrix.com/XenServer/6.2.0/1.0/en_gb/api/?c=GPU_group

        identity :reference

        attribute :gpu_types,           :aliases => :GPU_types
        attribute :description,         :aliases => :name_description
        attribute :name,                :aliases => :name_label
        attribute :other_config
        attribute :__pgpus,             :aliases => :PGPUs
        attribute :__vgpus,             :aliases => :VGPUs
        attribute :uuid
      end
    end
  end
end
