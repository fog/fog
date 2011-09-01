require 'fog/core/collection'
require 'fog/vsphere/models/compute/server'

module Fog
  module Compute
    class Vsphere

      class Servers < Fog::Collection

        model Fog::Compute::Vsphere::Server

        def all
          # Virtual Machine Managed Objects (vm_mobs)
          vm_mobs = connection.list_virtual_machines
          vm_attributes = vm_mobs.collect do |vm_mob|
            model.attribute_hash_from_mob(vm_mob)
          end

          load(vm_attributes)
        end

        def get(server_id)
          raise NotImplementedError
          # FIXME: (TODO) Make a raw API call
          # Massage the data into an attribute hash
          # Pass the attribute hash to new() to create a new instance of the model.
        rescue Fog::Compute::Vsphere::NotFound
          nil
        end

      end

    end
  end
end
