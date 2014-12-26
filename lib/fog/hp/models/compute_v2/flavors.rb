require 'fog/core/collection'
require 'fog/hp/models/compute_v2/flavor'

module Fog
  module Compute
    class HPV2
      class Flavors < Fog::Collection
        attribute :filters

        model Fog::Compute::HPV2::Flavor

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        def all(filters_arg = filters)
          details = filters_arg.delete(:details)
          self.filters = filters_arg
          non_aliased_filters = Fog::HP.convert_aliased_attributes_to_original(self.model, filters)
          if details
            data = service.list_flavors_detail(non_aliased_filters).body['flavors']
          else
            data = service.list_flavors(non_aliased_filters).body['flavors']
          end
          load(data)
        end

        def get(flavor_id)
          data = service.get_flavor_details(flavor_id).body['flavor']
          new(data)
        rescue Fog::Compute::HPV2::NotFound
          nil
        end
      end
    end
  end
end
