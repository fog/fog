require 'fog/core/collection'
require 'fog/openstack/models/compute/host'

module Fog
  module Compute
    class OpenStack

      class Hosts < Fog::Collection

        model Fog::Compute::OpenStack::Host

        def all
          data = service.list_hosts.body['hosts']
          load(data)
        end

        def get(host_name)
          if host = service.get_host_details(host_name).body['host']
            new({
              'host_name' => host_name,
              'details' => host}
            )
          end
        rescue Fog::Compute::OpenStack::NotFound
          nil
        end

      end

    end
  end
end
