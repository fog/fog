module Fog
  module Compute
    class OpenStack
      class Real
        def list_zones(options = {})
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => 'os-availability-zone.json',
            :query   => options
          )
        end
      end

      class Mock
        def list_zones(options = {})
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
