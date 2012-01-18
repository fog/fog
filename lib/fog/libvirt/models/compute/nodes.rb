require 'fog/core/collection'
require 'fog/libvirt/models/compute/node'

module Fog
  module Compute
    class Libvirt

      class Nodes < Fog::Collection

        model Fog::Compute::Libvirt::Node

        def all(filter=nil)
          data=[]
          node_info=Hash.new
          [:model, :memory, :cpus, :mhz, :nodes, :sockets, :cores, :threads].each do |param|
            begin
              node_info[param]=connection.node_get_info.send(param)
            rescue ::Libvirt::RetrieveError
              node_info[param]=nil
            end
          end
          [:type, :version, :node_free_memory, :max_vcpus].each do |param|
            begin
              node_info[param] = connection.send(param)
            rescue ::Libvirt::RetrieveError
              node_info[param]=nil
            end
          end
          node_info[:uri]=connection.uri
          data << { :raw => node_info }
          load(data)
        end


      end #class
    end #Class
  end #module
end #Module
