require 'fog/core/collection'
require 'fog/google/models/compute/firewall'

module Fog
  module Compute
    class Google
      class Firewalls < Fog::Collection
        model Fog::Compute::Google::Firewall

        def all
          data = service.list_firewalls.body
          load(data['items'] || [])
        end

        def get(identity)
          if firewall = service.get_firewall(identity).body
            new(firewall)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
