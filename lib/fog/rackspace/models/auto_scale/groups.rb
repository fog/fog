require 'fog/core/collection'
require 'fog/rackspace/models/auto_scale/group'

module Fog
  module Rackspace
    class AutoScale
      class Groups < Fog::Collection
        model Fog::Rackspace::AutoScale::Group

        # Returns list of autoscale groups
        #
        # @return [Fog::Rackspace::AutoScale::Groups] Retrieves a list groups.
        #
        # @raise [Fog::Rackspace::AutoScale:::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::AutoScale:::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::AutoScale:::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::AutoScale:::ServiceError]
        #
        # @see http://docs.rackspace.com/cas/api/v1.0/autoscale-devguide/content/GET_getGroups_v1.0__tenantId__groups_Groups.html
        def all
          data = service.list_groups.body['groups']
          load(data)
        end

        # Returns an individual autoscale group
        #
        # @return [Fog::Rackspace::AutoScale::Group] Retrieves a list groups.
        # @return nil if not found
        #
        # @raise [Fog::Rackspace::AutoScale:::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::AutoScale:::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::AutoScale:::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::AutoScale:::ServiceError]
        #
        # @see http://docs.rackspace.com/cas/api/v1.0/autoscale-devguide/content/GET_getGroupManifest_v1.0__tenantId__groups__groupId__Groups.html
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
