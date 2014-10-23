require 'fog/core/collection'
require 'fog/rackspace/models/networking/virtual_interface'
require 'fog/rackspace/models/compute_v2/server'

module Fog
  module Rackspace
    class Networking
      class VirtualInterfaces < Fog::Collection
        model Fog::Rackspace::Networking::VirtualInterface

        # Returns list of virtual interfaces for a server
        # @return [Fog::Rackspace::Networking::Servers] Retrieves a list virtual interfaces for server.
        # @raise [Fog::Rackspace::Networking::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Networking::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Networking::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Networking::ServiceError]
        # @note Fog's current implementation only returns 1000 servers
        # @note The filter parameter on the method is just to maintain compatability with other providers that support filtering.
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/List_Servers-d1e2078.html
        # @see Fog::Rackspace::Networking::Server#virtual_interfaces
        def all(options={})
          server  = server(options[:server])
          data    = service.list_virtual_interfaces(server.id).body['virtual_interfaces']
          objects = load(data)
          objects.each{ |obj| obj.attributes[:server] = server }
          objects
        end

        private

        def server(obj)
          server = case obj.class.to_s
            when "Fog::Compute::RackspaceV2::Server" then obj
            when "String" then Fog::Compute::RackspaceV2::Server.new(:id => obj, :service => service)
            else raise "Please pass in :server (either id or Fog::Compute::RackspaceV2::Server)"
          end

          raise "Server (#{server}) not found" unless server.present?

          server
        end
      end
    end
  end
end
