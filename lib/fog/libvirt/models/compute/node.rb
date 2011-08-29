require 'fog/core/model'

module Fog
  module Compute
    class Libvirt

      class Node < Fog::Model

        identity :uri

        attribute :model
        attribute :memory
        attribute :cpus
        attribute :mhz
        attribute :nodes
        attribute :sockets
        attribute :cores
        attribute :threads
        
        attribute :type
        attribute :version
        attribute :uri
        attribute :node_free_memory
        attribute :max_vcpus

        private

        def raw
          @raw
        end

        def raw=(new_raw)
          @raw = new_raw

          raw_attributes = new_raw

          merge_attributes(raw_attributes)
        end

      end

    end
  end

end
