require 'fog/core/collection'
require 'fog/openstack/models/compute/server'

module Fog
  module Compute
    class OpenStack

      class Servers < Fog::Collection

        attribute :filters

        model Fog::Compute::OpenStack::Server

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        def all(filters = filters)
          self.filters = filters
          data = service.list_servers_detail(filters).body['servers']
          load(data)
        end

        # Creates a new server and populates ssh keys
        # @return [Fog::Compute::OpenStack::Server]
        # @raise [Fog::Compute::OpenStack::NotFound] - HTTP 404
        # @raise [Fog::Compute::OpenStack::BadRequest] - HTTP 400
        # @raise [Fog::Compute::OpenStack::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::OpenStack::ServiceError]
        # @example
        #   service.servers.bootstrap :name => 'bootstrap-server',
        #                             :flavor_ref => service.flavors.first.id,
        #                             :image_ref => service.images.find {|img| img.name =~ /Ubuntu/}.id,
        #                             :public_key_path => '~/.ssh/fog_rsa.pub',
        #                             :private_key_path => '~/.ssh/fog_rsa'
        #
        def bootstrap(new_attributes = {})
          server = create(new_attributes)
          server.wait_for { ready? }
          server.setup(:password => server.password)
          server
        end

        def get(server_id)
          if server = service.get_server_details(server_id).body['server']
            new(server)
          end
        rescue Fog::Compute::OpenStack::NotFound
          nil
        end

      end

    end
  end
end
