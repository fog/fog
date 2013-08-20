require 'fog/core/collection'
require 'fog/rackspace/models/auto_scale/group'

module Fog
  module Rackspace
    class AutoScale
      class Groups < Fog::Collection

        model Fog::Rackspace::AutoScale::Group

        def all
          data = service.list_groups.body['groups']
          load(data)
        end

        def get(group_id)          
          data = service.get_group(group_id).body['group']
          new(data)
        rescue Fog::Rackspace::AutoScale::NotFound
          nil
        end
      end
    end
  end
end
