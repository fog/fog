module Fog
  module DNS
    class Rage4
      class Real
        # Shows global usage for all domains
        # ==== Parameters
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>

        def show_global_usage
          request(
                  :expects  => 200,
                  :method   => 'GET',
                  :path     => "/rapi/showcurrentglobalusage/" )
        end
      end
    end
  end
end
