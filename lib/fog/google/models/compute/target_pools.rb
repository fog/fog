require 'fog/core/collection'
require 'fog/google/models/compute/target_pool'

module Fog
  module Compute
    class Google
      class TargetPools < Fog::Collection
        model Fog::Compute::Google::TargetPool

        def all(filters={})
          if filters['region'].nil?
            data = []
            service.list_regions.body['items'].each do |region|
              data += service.list_target_pools(region['name']).body['items'] || []
            end
          else
            data = service.list_target_pools(filters['region']).body['items'] || []
          end
          load(data)
        end

        def get(identity, region=nil)
          response = nil
          if region.nil?
            service.regions.all.each do |region|
              begin
                response = service.get_target_pool(identity, region.name)
                break if response.status == 200
              rescue Fog::Errors::Error
              end
            end
          else
            response = service.get_target_pool(identity, region)
          end
          return nil if response.nil?
          new(response.body)
        end
      end
    end
  end
end
