require 'fog/core/collection'
require 'fog/linode/models/compute/flavor'

module Fog
  module Compute
    class Linode
      class Flavors < Fog::Collection
        model Fog::Compute::Linode::Flavor

        def all
          load flavors
        end

        def get(id)
          new flavors(id).first
        rescue Fog::Compute::Linode::NotFound
          nil
        end

        private
        def flavors(id=nil)
          service.avail_linodeplans(id).body['DATA'].map { |flavor| map_flavor flavor }
        end

        def map_flavor(flavor)
          flavor = flavor.each_with_object({}) { |(k, v), h| h[k.downcase.to_sym] = v  }
          flavor.merge! :id => flavor[:planid], :name => flavor[:label],
                        :transfer => flavor[:xfer], :price_hourly => flavor[:hourly],
                        :available => map_available(flavor[:avail])
        end

        def map_available(available)
          return nil unless available
          available.each_with_object({}) { |(k, v), h| h[k.to_i] = v }
        end
      end
    end
  end
end
