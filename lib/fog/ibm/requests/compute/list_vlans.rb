module Fog
  module Compute
    class IBM
      class Real

        # Get vlans
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * images<~Array>
        # TODO: docs
        def list_vlans
          request(
            :method   => 'GET',
            :expects  => 200,
            :path     => '/offerings/vlan'
          )
        end

      end
    end
  end
end
