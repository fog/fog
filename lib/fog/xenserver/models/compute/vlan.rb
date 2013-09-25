require 'fog/core/model'

module Fog
  module Compute
    class XenServer

      class VLAN < Fog::Model
        # API Reference here:
        # @see http://docs.vmd.citrix.com/XenServer/5.6.0/1.0/en_gb/api/?c=VLAN

        identity :reference

        attribute :uuid
        attribute :tag,                :type => :integer
        attribute :__untagged_pif,     :aliases => :untagged_PIF
        attribute :__tagged_pif,       :aliases => :tagged_PIF

        # @return [Fog::Compute::XenServer::PIF] interface on which traffic is tagged
        #
        # @see http://docs.vmd.citrix.com/XenServer/6.1.0/1.0/en_gb/api/?c=VLAN
        #
        def untagged_pif
          service.pifs.get __untagged_pif
        end
        
        # @return [Fog::Compute::XenServer::PIF] interface on which traffic is untagged
        #
        # @see http://docs.vmd.citrix.com/XenServer/6.1.0/1.0/en_gb/api/?c=VLAN
        #
        def tagged_pif
          service.pifs.get __tagged_pif
        end
        
        # Creates a new VLAN.
        #
        #     service = Fog::Compute[:xenserver]
        #
        #     # create a network 'foo-net'
        #     net = service.networks.create :name => 'foo-net'
        #
        #     # get the eth0 physical interface where the
        #     # VLAN subinterface will be added
        #     pif = service.pifs.find { |p| p.device == 'eth0' and p.physical }
        #
        #     Fog::Compute[:xenserver].vlans.create :tag => 123,
        #                                           :network => net,
        #                                           :pif => pif
        def save
          requires :tag
          pif = attributes[:pif]
          net = attributes[:network]
          unless pif and net
            raise Fog::Error.new 'save requires :pif and :network attributes'
          end
          ref = service.create_vlan attributes[:pif].reference, 
                                    tag,
                                    attributes[:network].reference
          data = service.get_record ref, 'VLAN'
          merge_attributes data
          true
        end

        # Destroys a VLAN.
        #
        #     service = Fog::Compute[:xenserver]
        #
        #     # Find VLAN 123 and destroy it
        #     (service.vlans.find { |v| v.tag == 123 }).destroy
        #
        def destroy
          requires :reference
          service.destroy_vlan reference
          true
        end

      end

    end
  end
end
