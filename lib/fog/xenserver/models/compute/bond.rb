require 'fog/core/model'

module Fog
  module Compute
    class XenServer
      class Bond < Fog::Model
        # API Reference here:
        # http://docs.vmd.citrix.com/XenServer/6.2.0/1.0/en_gb/api/?c=Bond

        identity :reference

        attribute :links_up
        attribute :__master,            :aliases => :master
        attribute :mode
        attribute :other_config
        attribute :__primary_slave,     :aliases => :primary_slave
        attribute :properties
        attribute :__slaves,            :aliases => :slaves
        attribute :uuid
      end
    end
  end
end
