require 'fog/core/collection'
require 'fog/vsphere/models/compute/server'

module Fog
  module Compute
    class Vsphere

      class Servers < Fog::Collection

        model Fog::Compute::Vsphere::Server

        def all
          response = connection.list_virtual_machines
          load(response['virtual_machines'])
        end

        def get(id)
          # Is the id a managed_object_reference?  This may be the case if we're reloading
          # a model of a VM in the process of being cloned, since it
          # will not have a instance_uuid yet.
          if id =~ /^vm-/
            response = connection.find_vm_by_ref('vm_ref' => id)
            server_attributes = response['virtual_machine']
          else
            response = connection.list_virtual_machines('instance_uuid' => id)
            server_attributes = response['virtual_machines'].first
          end
          new(server_attributes)
        rescue Fog::Compute::Vsphere::NotFound
          nil
        end

      end

    end
  end
end
