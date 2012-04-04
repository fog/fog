require 'fog/core/collection'
require 'fog/libvirt/models/compute/server'

module Fog
  module Compute
    class Libvirt

      class Servers < Fog::Collection

        model Fog::Compute::Libvirt::Server

        def all(filter={})
          load(connection.list_domains(filter))
        end

        def get(uuid)
          data = connection.list_domains(:uuid => uuid)
          new data.first if data
        end

      end
    end
  end
end
