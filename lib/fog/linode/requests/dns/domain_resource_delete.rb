module Fog
  module DNS
    class Linode
      class Real
        # Delete the given resource from a domain
        #
        # ==== Parameters
        # * domain_id<~Integer>: id of domain resource belongs to
        # * resource_id<~Integer>: id of resouce to delete
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * DATA<~Hash>:
        #       * resource_id<~Integer>:  resource id that was deleted
        def domain_resource_delete(domain_id, resource_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => { :api_action => 'domain.resource.delete', :domainId => domain_id, :resourceID => resource_id }
          )
        end
      end
    end
  end
end
