require 'fog/core/collection'
require 'fog/openstack/models/compute/ip'

module Fog
  module Compute
    class OpenStack

      class Ips < Fog::Collection

        model Fog::Compute::OpenStack::Ip

        def all
          data = connection.list_ips.body["floating_ips"]
          load(data)
        end

        def get(flavor_id)
          data = connection.get_flavor_details(flavor_id).body['os-floating-ip']
          new(data)
        rescue Fog::Compute::OpenStack::NotFound
          nil
        end

      end

    end
  end
end
