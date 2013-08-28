require 'fog/core/collection'
require 'fog/rackspace/models/auto_scale/policy'

module Fog
  module Rackspace
    class AutoScale
      class Policies < Fog::Collection

        model Fog::Rackspace::AutoScale::Policy

        attr_accessor :group

        def all
          data = service.list_policies(group.id).body['policies']
          load(data)
        end

        def get(policy_id)          
          data = service.get_policy(group.id, policy_id).body['policy']
          data['group_id'] = group.id
          new(data)
        rescue Fog::Rackspace::AutoScale::NotFound
          nil
        end

        def create(attributes = {})
          attributes['group_id'] = group.id
          super(attributes)
        end

      end
    end
  end
end