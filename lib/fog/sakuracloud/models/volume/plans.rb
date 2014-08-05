require 'fog/core/collection'
require 'fog/sakuracloud/models/volume/plan'

module Fog
  module Volume
    class SakuraCloud
      class Plans < Fog::Collection
        model Fog::Volume::SakuraCloud::Plan

        def all
          load service.list_plans.body['DiskPlans']
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
