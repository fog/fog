require 'fog/core/collection'
require 'fog/openstack/models/planning/role'

module Fog
  module Openstack
    class Planning
      class Roles < Fog::Collection
        model Fog::Openstack::Planning::Role

        def all(options = {})
          load(service.list_roles(options).body)
        end

        alias_method :summary, :all

      end
    end
  end
end
