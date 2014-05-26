require 'fog/core/collection'
require 'fog/sakuracloud/models/compute/plan'

module Fog
  module Compute
    class SakuraCloud
      class Plans < Fog::Collection
        model Fog::Compute::SakuraCloud::Plan

        def all
          load service.list_plans.body['ServerPlans']
        end

        def get(id)
          all.find { |f| f.id == id }
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
