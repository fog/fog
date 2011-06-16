module Fog
  module DNS
    class Linode
      class Real

        # Delete the given domain from the list Linode hosts
        #
        # ==== Parameters
        # * domain_id<~Integer>: id of domain to delete
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * DATA<~Hash>:
        # TODO: docs
        def domain_delete(domain_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => { :api_action => 'domain.delete', :domainId => domain_id }
          )
        end

      end
    end
  end
end
