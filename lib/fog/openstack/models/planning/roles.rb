require 'fog/core/collection'
require 'fog/openstack/models/planning/role'

module Fog
  module Openstack
    class Planning
      class Roles < Fog::Collection
        model Fog::Openstack::Planning::Role

        def all
          load(service.list_roles.body)
        end
      end
    end
  end
end
