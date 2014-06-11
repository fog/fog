require 'fog/core/collection'
require 'fog/hp/models/lb/algorithm'

module Fog
  module HP
    class LB
      class Algorithms < Fog::Collection
        model Fog::HP::LB::Algorithm

        def all
          data = service.list_algorithms.body['algorithms']
          load(data)
        end

        def get(name)
          data = service.list_algorithms.body['algorithms']
          algorithm = data.find {|algo| algo['name'] == name}
          new(algorithm)
        rescue Fog::HP::LB::NotFound
          nil
        end
      end
    end
  end
end
