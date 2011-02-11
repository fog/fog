module Fog
  module Linode
    class Compute
      class Real

        # Get available data centers
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        # TODO: docs
        def avail_datacenters
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => { :api_action => 'avail.datacenters' }
          )
        end

      end
    end
  end
end
