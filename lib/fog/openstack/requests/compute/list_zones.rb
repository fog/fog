module Fog
  module Compute
    class OpenStack
      class Real
        def list_zones(*args)
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => 'os-availability-zone.json'
          )
        end
      end

      class Mock
        def list_zones(*args)
          Excon::Response.new(
            :body   => { "availabilityZoneInfo" => [
                  {
                      "zoneState" => {
                          "available" => true
                      },
                      "hosts" => nil,
                      "zoneName" => "nova"
                  }
              ] },
            :status => 200
          )
        end
      end
    end
  end
end
