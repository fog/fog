module Fog
  module DNS
    class Rage4
      class Real

        # Delete a specific omain
        # ==== Parameters
        #
        # ==== Returns
        # * response<~Excon::Response>:
        def show_global_usage
          request(
                  :expects  => 200,
                  :method   => 'GET',
                  :path     => "/rapi/showcurrentglobalusage/#{id}" )

        end

      end

    end
  end
end
