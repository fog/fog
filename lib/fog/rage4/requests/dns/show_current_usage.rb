module Fog
  module DNS
    class Rage4
      class Real
        # Shows current usage for a single domain
        # ==== Parameters
        # * id<~Integer> - domain name numeric ID
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>
        def show_current_usage(id)
          request(
                  :expects  => 200,
                  :method   => 'GET',
                  :path     => "/rapi/showcurrentusage/#{id}" )
        end
      end
    end
  end
end
