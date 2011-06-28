require 'fog/core/model'
require 'fog/compute/models/libvirt/util'

module Fog
  module Compute
    class Libvirt

      class Network < Fog::Model

        include Fog::Compute::LibvirtUtil

        identity :id        
        attribute :uuid
        attribute :name
        attribute :bridge_name
        
        attribute :xml_desc
        
        attr_reader :template_path,:network_mode,:bridge_name

        ##https://www.redhat.com/archives/libvirt-users/2011-May/msg00091.html
        # Bridged VLAN
        
        # https://www.redhat.com/archives/libvirt-users/2011-April/msg00006.html
        # Routed network without IP
        
        # http://wiki.libvirt.org/page/Networking
        #http://wiki.libvirt.org/page/VirtualNetworking#Virtual_network_switches
        def initialize(attributes = {})
          
          @template_path  = attributes[:template_path]  || "network.xml.erb"
          @network_mode  = attributes[:network_mode]  || "nat"
          @bridge_name  = attributes[:bridge_name]  || "virbr0"
          template_xml
        end
        
        def destroy()
          requires :raw
          raw.destroy
#          raw.undefine
          true
        end
        
        private

        def raw
          @raw
        end

        def raw=(new_raw)
          @raw = new_raw

          raw_attributes = { 
            :id => new_raw.uuid,
            :uuid => new_raw.uuid,
            :name => new_raw.name,
            :bridge_name => new_raw.bridge_name,
            :xml_desc => new_raw.xml_desc,
          }

          merge_attributes(raw_attributes)

        end
        
      end

    end
  end

end
