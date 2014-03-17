require 'fog/core/collection'
require 'fog/rackspace/models/compute_v2/virtual_interface'
require 'fog/rackspace/models/compute_v2/server'

module Fog
  module Compute
    class RackspaceV2
      class VirtualInterfaces < Fog::Collection
        model Fog::Compute::RackspaceV2::VirtualInterface

        attr_reader :server

        def server=(obj)
          if obj.is_a?(Server)
            @server = obj
          else
            @server = Fog::Compute::RackspaceV2::Server.new :id => obj, :service => service
          end
        end

        # Returns list of virtual interfaces for a server
        # @return [Fog::Compute::RackspaceV2::Servers] Retrieves a list virtual interfaces for server.
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @note Fog's current implementation only returns 1000 servers
        # @note The filter parameter on the method is just to maintain compatability with other providers that support filtering.
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/List_Servers-d1e2078.html
        # @see Fog::Compute::RackspaceV2::Server#virtual_interfaces
        def all
          raise "Please access this collection via Server#virtual_interfaces" unless self.server

          data = service.list_virtual_interfaces(server.id).body['virtual_interfaces']
          objects = load(data)
          objects.each {|obj| obj.attributes[:server] = self.server}
          objects
        end

        def new(attributes = {})
          super({ :server => server }.merge(attributes))
        end
      end
    end
  end
end
