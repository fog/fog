module Fog
  module Compute
    class DigitalOceanV2
      class Real
        def list_flavors
          request(
            :expects => [200],
            :method  => 'GET',
            :path    => '/v2/sizes'
          )
        end
      end

    # noinspection RubyStringKeysInHashInspection
      class Mock
        def list_flavors
          response        = Excon::Response.new
          response.status = 200
          response.body   = {

            'sizes' => [
              {
                'slug'          => '512mb',
                'memory'        => 512,
                'vcpus'         => 1,
                'disk'          => 20,
                'transfer'      => 1.0,
                'price_monthly' => 5.0,
                'price_hourly'  => 0.00744,
                'regions'       => %w(nyc1 sgp1 ams1 ams2 sfo1 nyc2 lon1 nyc3 ams3),
                'available'     => true
              },
              {
                'slug'          => '1gb',
                'memory'        => 1024,
                'vcpus'         => 1,
                'disk'          => 30,
                'transfer'      => 2.0,
                'price_monthly' => 10.0,
                'price_hourly'  => 0.01488,
                'regions'       => %w(nyc2 sgp1 ams1 sfo1 lon1 nyc3 ams3 ams2 nyc1),
                'available'     => true
              },
              {
                'slug'          => '2gb',
                'memory'        => 2048,
                'vcpus'         => 2,
                'disk'          => 40,
                'transfer'      => 3.0,
                'price_monthly' => 20.0,
                'price_hourly'  => 0.02976,
                'regions'       => %w(nyc2 sfo1 ams1 sgp1 ams2 lon1 nyc3 ams3 nyc1),
                'available'     => true
              },
              {
                'slug'          => '4gb',
                'memory'        => 4096,
                'vcpus'         => 2,
                'disk'          => 60,
                'transfer'      => 4.0,
                'price_monthly' => 40.0,
                'price_hourly'  => 0.05952,
                'regions'       => %w(nyc2 sfo1 ams1 sgp1 ams2 lon1 nyc3 ams3 nyc1),
                'available'     => true
              },
              {
                'slug'          => '8gb',
                'memory'        => 8192,
                'vcpus'         => 4,
                'disk'          => 80,
                'transfer'      => 5.0,
                'price_monthly' => 80.0,
                'price_hourly'  => 0.11905,
                'regions'       => %w(nyc2 sfo1 sgp1 ams1 ams2 nyc1 lon1 nyc3 ams3),
                'available'     => true
              },
              {
                'slug'          => '16gb',
                'memory'        => 16384,
                'vcpus'         => 8,
                'disk'          => 160,
                'transfer'      => 6.0,
                'price_monthly' => 160.0,
                'price_hourly'  => 0.2381,
                'regions'       => %w(sgp1 nyc1 sfo1 ams2 nyc3 lon1 nyc2 ams1 ams3),
                'available'     => true
              },
              {
                'slug'          => '32gb',
                'memory'        => 32768,
                'vcpus'         => 12,
                'disk'          => 320,
                'transfer'      => 7.0,
                'price_monthly' => 320.0,
                'price_hourly'  => 0.47619,
                'regions'       => %w(nyc2 sgp1 ams2 nyc1 sfo1 lon1 ams3 nyc3),
                'available'     => true
              },
              {
                'slug'          => '48gb',
                'memory'        => 49152,
                'vcpus'         => 16,
                'disk'          => 480,
                'transfer'      => 8.0,
                'price_monthly' => 480.0,
                'price_hourly'  => 0.71429,
                'regions'       => %w(sgp1 ams2 sfo1 nyc1 lon1 nyc2 ams3 nyc3),
                'available'     => true
              },
              {
                'slug'          => '64gb',
                'memory'        => 65536,
                'vcpus'         => 20,
                'disk'          => 640,
                'transfer'      => 9.0,
                'price_monthly' => 640.0,
                'price_hourly'  => 0.95238,
                'regions'       => %w(sgp1 nyc1 nyc2 sfo1 lon1 ams3 ams2 nyc3),
                'available'     => true
              }
            ],
            'links' => {},
            'meta'  => {'total' => 9}
          }

          response
        end
      end
    end
  end
end
