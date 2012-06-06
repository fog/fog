require 'fog/ecloudv2/models/compute/compute_pool'

module Fog
  module Compute
    class Ecloudv2
      class ComputePools < Fog::Ecloudv2::Collection

        undef_method :create

        attribute :href, :aliases => :Href

        model Fog::Compute::Ecloudv2::ComputePool

        def all
          check_href!(:message => "the Compute Pool href of the Environment you want to enumerate")
          data = connection.get_compute_pools(href).body[:ComputePool]
          load(data)
        end

        def get(uri)
          if data = connection.get_compute_pool(uri)
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
