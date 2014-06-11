module Fog
  module Compute
    class GoGrid
      class Real
        # List passwords
        #
        # ==== Parameters
        # * options<~Hash>:
        #   * 'datacenter'<~String> - datacenter to limit results to
        #   * 'isSandbox'<~String> - If true only  returns Image Sandbox servers, in ['false', 'true']
        #   * 'num_items'<~Integer> - Number of items to return
        #   * 'page'<~Integer> - Page index for paginated results
        #   * 'server.type'<~String> - server type to limit results to
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        # TODO: docs
        def support_password_list(options={})
          request(
            :path     => 'support/password/list',
            :query    => options
          )
        end
      end
    end
  end
end
