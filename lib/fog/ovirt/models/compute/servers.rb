require 'fog/core/collection'
require 'fog/ovirt/models/compute/server'
require 'fog/ovirt/models/compute/helpers/collection_helper'

module Fog
  module Compute
    class Ovirt

      class Servers < Fog::Collection

        include Fog::Compute::Ovirt::Helpers::CollectionHelper
        model Fog::Compute::Ovirt::Server

        def all(filters = {})
          attrs = connection.client.vms(filters).map { |server| ovirt_attrs(server) }
          load attrs
        end

        def get(id)
          new ovirt_attrs(connection.client.vm(id))
        end

        def bootstrap(new_attributes = {})
          server = create(new_attributes)
          server.wait_for { stopped? }
          server.start
          server
        end

      end
    end
  end
end
