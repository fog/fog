require 'fog/core/collection'
require 'fog/libvirt/models/compute/network'

module Fog
  module Compute
    class Libvirt

      class Networks < Fog::Collection

        model Fog::Compute::Libvirt::Network

        def all(filter=nil)
          data=[]
          if filter.nil?
            connection.list_networks.each do |networkname|
              network=connection.lookup_network_by_name(networkname)
              data << { :raw => network }
            end
            connection.list_defined_networks.each do |networkname|
              network=connection.lookup_network_by_name(networkname)
              data << { :raw => network}
            end
          else
            network=nil
            begin
              network=get_by_uuid(filter[:uuid]) if filter.has_key?(:uuid)
              network=get_by_name(filter[:name]) if filter.has_key?(:name)
            rescue ::Libvirt::RetrieveError
              return nil
            end
            data << { :raw => network}
          end

          load(data)
        end

        def get(uuid)
          self.all(:uuid => uuid).first
        end

        #private # Making these private, screws up realod
        # Retrieve the network by uuid
        def get_by_uuid(uuid)
          network=connection.lookup_network_by_uuid(uuid)
          return network
          #          new(:raw => network)
        end

        # Retrieve the network by name
        def get_by_name(name)
          network=connection.lookup_network_by_name(name)
          return network
          #          new(:raw => network)
        end


      end #class

    end #Class
  end #module
end #module
