require 'fog/core/collection'
require 'fog/vsphere/models/compute/interface'

module Fog
  module Compute
    class Vsphere
      class Interfaces < Fog::Collection
        model Fog::Compute::Vsphere::Interface

        attribute :server_id

        def all(filters = {})
          requires :server_id

          case server
            when Fog::Compute::Vsphere::Server
              load service.list_vm_interfaces(server.id)
            when Fog::Compute::Vsphere::Template
              load service.list_template_interfaces(server.id)
            else
            raise 'interfaces should have vm or template'
          end

          self.each { |interface| interface.server_id = server.id }
          self
        end

        def get(id)
          requires :server_id

          case server
            when Fog::Compute::Vsphere::Server
              interface = service.get_vm_interface(server.id, :key => id, :mac=> id, :name => id)
            when Fog::Compute::Vsphere::Template
              interface = service.get_template_interfaces(server.id, :key => id, :mac=> id, :name => id)
            else

            raise 'interfaces should have vm or template'
          end

          if interface
            Fog::Compute::Vsphere::Interface.new(interface.merge(:server_id => server.id, :service => service))
          else
            nil
          end
        end

        def new(attributes = {})
          if server_id
            super({ :server_id => server_id  }.merge(attributes))
          else
            super
          end
        end

        def server
          return nil if server_id.nil?
          service.servers.get(server_id)
        end

        def server=(new_server)
          server_id = new_server.id
        end
      end
    end
  end
end
