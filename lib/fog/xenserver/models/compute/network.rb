require 'fog/core/model'

module Fog
  module Compute
    class XenServer

      class Network < Fog::Model
        # API Reference here:
        # http://docs.vmd.citrix.com/XenServer/5.6.0/1.0/en_gb/api/?c=network

        identity :reference

        attribute :uuid
        attribute :__vifs,             :aliases => :VIFs
        attribute :tags
        attribute :mtu,                :aliases => :MTU
        attribute :bridge
        attribute :description,        :aliases => :name_description
        attribute :name,               :aliases => :name_label
        attribute :other_config
        attribute :__pifs,               :aliases => :PIFs
        attribute :allowed_operations
        attribute :current_operations
        attribute :blobs

        def refresh
          data = service.get_record( reference, 'network' )
          merge_attributes( data )
          true
        end

        #
        # Return the list of network related PIFs
        #
        def pifs
          p = []
          __pifs.each do |pif|
            p << service.pifs.get(pif)
          end
          p
        end

        #
        # Return the list of network related VIFs
        #
        def vifs
          v = []
          __vifs.each do |vif|
            v << service.vifs.get(vif)
          end
          v
        end

        # Creates a new network
        #
        #     service = Fog::Compute[:xenserver]
        #
        #     # create network 'foonet'
        #     net = service.networks.create :name => 'foonet',
        #                                   :description => 'test network'
        #
        # @return [Boolean]
        #
        def save
          requires :name
          ref = service.create_network name, attributes
          data = service.get_record ref, 'network'
          merge_attributes data
          true
        end

        # Destroys a network
        #
        #     service = Fog::Compute[:xenserver]
        #
        #     # find network 'foonet' and destroy it
        #     net = service.networks.find { |net| net.name == 'foonet' }
        #     net.destroy
        #
        # @return [Boolean]
        #
        def destroy
          requires :reference
          service.destroy_network reference
          true
        end
      end

    end
  end
end
