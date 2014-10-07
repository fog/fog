require 'fog/core/collection'
require 'fog/google/models/compute/target_instance'

module Fog
  module Compute
    class Google
      class TargetInstances < Fog::Collection
        model Fog::Compute::Google::TargetInstance

        def all(zone = nil)
          if zone.nil?
            data = []
            data = service.list_target_instances.body['items'] || []
          
          else
            data = service.list_target_instances(zone).body['items'] || []
          end
          load(data)
        end

        def get(identity, zone=nil)
            response = service.get_target_instance(identity, zone)
            new(response.body) unless response.nil?
        end
      end
    end
  end
end
