require 'fog/ecloud/models/compute/compute_pool'

module Fog
  module Compute
    class Ecloud
      class ComputePools < Fog::Ecloud::Collection
        undef_method :create

        attribute :href, :aliases => :Href

        model Fog::Compute::Ecloud::ComputePool

        def all
          check_href!(:message => "the Compute Pool href of the Environment you want to enumerate")
          data = service.get_compute_pools(href).body[:ComputePool]
          load(data)
        end

        def get(uri)
          if data = service.get_compute_pool(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end

        def from_data(data)
          new(data)
        end
      end
    end
  end
end
