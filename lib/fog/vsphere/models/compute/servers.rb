require 'fog/core/collection'
require 'fog/vsphere/models/compute/server'

module Fog
  module Compute
    class Vsphere

      class Servers < Fog::Collection

        model Fog::Compute::Vsphere::Server

        # Public: list all vms in the given folder
        # folder - 'folder_path' will work as a filter.
        # if empty arguments then simply listing everything.
        #
        # Returns the vm array
        def all(filters = {})
          # REVISIT: I'm not sure if this is the best way to implement search
          # filters on a collection but it does work.  I need to study the AWS
          # code more to make sure this matches up.
          filters['folder'] ||= attributes['folder']
          response = connection.list_virtual_machines(filters)
          load(response['virtual_machines'])
        end

        # Public: get vm with given id
        # id - can be vm management object id or instance_uuid
        #
        # Returns the server object with given id
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
