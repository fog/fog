require 'fog/core/collection'
require 'fog/libvirt/models/compute/interface'

module Fog
  module Compute
    class Libvirt

      class Interfaces < Fog::Collection

        model Fog::Compute::Libvirt::Interface

        def all(filter=nil)
          data=[]
          if filter.nil?
            connection.raw.list_interfaces.each do |ifname|
              interface=connection.raw.lookup_interface_by_name(ifname)
              data << { :raw => interface }
            end
            connection.raw.list_defined_interfaces.each do |ifname|
              interface=connection.raw.lookup_interface_by_name(ifname)
              data << { :raw => interface }
            end

          else
            interface=nil
            begin
              interface=get_by_name(filter[:name]) if filter.has_key?(:name)
              interface=get_by_mac(filter[:mac]) if filter.has_key?(:mac)
            rescue ::Libvirt::RetrieveError
              return nil
            end
            data << { :raw => interface}
          end

          load(data)
        end

        def get(key)
          self.all(:name => name).first
        end

        #private # Making these private, screws up realod
        # Retrieve the interface by name
        def get_by_name(name)
          interface=connection.raw.lookup_interface_by_name(name)
          return interface
          #          new(:raw => interface)
        end

        # Retrieve the interface by name
        def get_by_mac(mac)
          interface=connection.raw.lookup_interface_by_mac(mac)
          return interface
          #          new(:raw => interface)
        end


      end #class

    end #Class
  end #module
end #module
