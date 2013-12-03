require 'fog/core/collection'
require 'fog/vsphere/models/compute/volume'

module Fog
  module Compute
    class Vsphere

      class Volumes < Fog::Collection

        attribute :server

        model Fog::Compute::Vsphere::Volume

        def all(filters = {})
          requires :server

          case server
            when Fog::Compute::Vsphere::Server
              load service.list_vm_volumes(server.id)
            when Fog::Compute::Vsphere::Template
              load service.list_template_volumes(server.id)
            else
              raise 'volumes should have vm or template'
            end

          self.each { |volume| volume.server_id = server.id }
          self
        end

        def get(id)
          new service.get_volume(id)
        end

        def new(attributes = {})
          if server
            # Default to the root volume datastore if one is not configured.
            datastore = ! attributes.has_key?(:datastore) && self.any? ? self.first.datastore : nil

            super({ :server_id => server.id, :datastore => datastore }.merge!(attributes))
          else
            super
          end
        end

     end
    end
  end
end
