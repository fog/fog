require 'fog/core/collection'
require 'fog/compute/models/libvirt/interface'

module Fog
  module Compute
    class Libvirt

      class Interfaces < Fog::Collection

        model Fog::Compute::Libvirt::Interface

        def all 
          data=[]          
          connection.list_interfaces.each do |ifname|
            interface=connection.lookup_interface_by_name(ifname)            
            data << { :raw => interface }
          end          
          load(data)
        end

        # Retrieve the interface by name
        def get(name)
          interface=connection.lookup_interface_by_name(name)
          new(:raw => interface)
        end

      end #class

    end #Class
  end #module
end #module
