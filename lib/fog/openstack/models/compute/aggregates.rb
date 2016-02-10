require 'fog/openstack/models/collection'
require 'fog/openstack/models/compute/aggregate'

module Fog
  module Compute
    class OpenStack
      class Aggregates < Fog::OpenStack::Collection
        model Fog::Compute::OpenStack::Aggregate

        def all(options = {})
          load_response(service.list_aggregates(options), 'aggregates')
        end

        def find_by_id(id)
          new(service.get_aggregate(id).body['aggregate'])
        end
        alias_method :get, :find_by_id

        def destroy(id)
          aggregate = self.find_by_id(id)
          aggregate.destroy
        end
      end
    end
  end
end
