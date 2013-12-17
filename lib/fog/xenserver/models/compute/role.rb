require 'fog/core/model'

module Fog
  module Compute
    class XenServer
      class Role < Fog::Model
        # API Reference here:
        # http://docs.vmd.citrix.com/XenServer/6.2.0/1.0/en_gb/api/?c=role

        identity :reference

        attribute :description,         :aliases => :name_description
        attribute :name,                :aliases => :name_label
        attribute :__subroles,          :aliases => :subroles
        attribute :uuid
      end
    end
  end
end
