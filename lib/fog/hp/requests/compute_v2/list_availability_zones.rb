module Fog
  module Compute
    class HPV2
      class Real
        # List all availability zones
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #   * 'availabilityZoneInfo'<~Array>
        #     * 'zoneName'<~String> - Name of the availability zone i.e. az1, az2, az3 etc.
        #     * 'hosts'<~String> - List of hosts
        #     * 'zoneState'<~Hash>
        #       * 'available'<~Boolean> - State of the availability zone, i.e. true/false
        def list_availability_zones
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => 'os-availability-zone'
          )
        end
      end

      class Mock
        def list_availability_zones
          response = Excon::Response.new
          response.status = 200
          response.body = {
            'availabilityZoneInfo' => [
                {'zoneState' => {'available' => true},
                 'hosts' => nil,
                 'zoneName' => 'az1'},
                {'zoneState' => {'available' => true},
                 'hosts' => nil,
                 'zoneName' => 'az2'}
            ]
          }
          response
        end
      end
    end
  end
end
