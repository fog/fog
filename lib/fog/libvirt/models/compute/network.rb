require 'fog/core/model'
require 'fog/libvirt/models/compute/util'

module Fog
  module Compute
    class Libvirt

      class Network < Fog::Model

        include Fog::Compute::LibvirtUtil

        identity :uuid

        attribute :name
        attribute :bridge_name
        attribute :xml

        ##https://www.redhat.com/archives/libvirt-users/2011-May/msg00091.html
        # Bridged VLAN

        # https://www.redhat.com/archives/libvirt-users/2011-April/msg00006.html
        # Routed network without IP

        # http://wiki.libvirt.org/page/Networking
        #http://wiki.libvirt.org/page/VirtualNetworking#Virtual_network_switches
        def initialize(attributes = {})
          super
        end

        def save
          raise Fog::Errors::Error.new('Creating a new network is not yet implemented. Contributions welcome!')
        end

        def destroy()
          requires :raw
          raw.destroy
          true
        end

        private

        def raw
          @raw
        end

        def raw=(new_raw)
          @raw = new_raw

          raw_attributes = {
            :uuid => new_raw.uuid,
            :name => new_raw.name,
            :bridge_name => new_raw.bridge_name,
            :xml => new_raw.xml_desc,
          }

          merge_attributes(raw_attributes)

        end

      end

    end
  end

end
