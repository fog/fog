module Fog
  module Linode
    class DNS
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

      class Mock

        def domain_delete(domain_id)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
