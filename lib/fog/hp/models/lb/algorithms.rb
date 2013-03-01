require 'fog/core/collection'
require 'lib/fog/hp/models/lb/algorithm'

module Fog
  module HP
    class LB
      class Algorithms < Fog::Collection
        model Fog::HP::LB::Algorithms

        def all
          data = connection.list_algorithms.body['algorithms']
          load(data)
        end

        def get(record_id)
          record = connection.get_algorithm_details(record_id).body['algorithm']
          new(record)
        rescue Fog::HP::LB::NotFound
          nil
        end

      end
    end
  end
end