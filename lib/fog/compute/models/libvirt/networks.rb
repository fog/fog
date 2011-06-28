require 'fog/core/collection'
require 'fog/compute/models/libvirt/network'

module Fog
  module Compute
    class Libvirt

      class Networks < Fog::Collection

        model Fog::Compute::Libvirt::Network

        def all 
          data=[]          
          connection.list_networks.each do |networkname|
            network=connection.lookup_network_by_name(networkname)            
            data << { :raw => network }
          end          
          load(data)
        end

        # Retrieve the network by uuid
        def get(uuid)
          network=connection.lookup_network_by_uuid(uuid)
          new(:raw => network)
        end

      end #class

    end #Class
  end #module
end #module
