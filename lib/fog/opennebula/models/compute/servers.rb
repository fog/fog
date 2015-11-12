require 'fog/core/collection'
require 'fog/opennebula/models/compute/server'


module Fog
  module Compute
    class OpenNebula

      class Servers < Fog::Collection

        model Fog::Compute::OpenNebula::Server

        def all(filter={})
          load(service.list_vms(filter))
        end

        def get(id)
          data = service.list_vms({:id => id})
          new data.first unless data.empty?
        end

        def shutdown(id)
          service.vm_shutdown(id)
        end

      end
    end
  end
end

