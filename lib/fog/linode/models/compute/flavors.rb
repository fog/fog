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
        rescue Fog::Linode::Compute::NotFound
          nil
        end

        private
        def flavors(id=nil)
          connection.avail_linodeplans(id).body['DATA'].map { |flavor| map_flavor flavor }
        end
        
        def map_flavor(flavor)
          flavor = flavor.each_with_object({}) { |(k, v), h| h[k.downcase.to_sym] = v  }
          flavor.merge! :id => flavor[:planid], :name => flavor[:label]
        end
      end
    end
  end
end
