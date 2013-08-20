require 'fog/core/collection'
require 'fog/rackspace/models/auto_scale/policy'

module Fog
  module Rackspace
    class AutoScale
      class Policies < Fog::Collection

        model Fog::Rackspace::AutoScale::Policy

        def all
          data = service.list_policies.body['policies']
          load(data)
        end

        def get(policy_id)          
          data = service.get_policy(policy_id).body['policy']
          new(data)
        rescue Fog::Rackspace::AutoScale::NotFound
          nil
        end
      end
    end
  end
end