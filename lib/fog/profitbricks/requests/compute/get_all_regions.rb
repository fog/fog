module Fog
    module Compute
        class ProfitBricks
            class Real
                def get_all_regions(options = {})
                    response        = Excon::Response.new
                    response.status = 200
                    response.body   = {
                      'getAllRegionsResponse' => [
                         {
                           'regionId'   => 'c0420cc0-90e8-4f4b-8860-df0a07d18047',
                           'regionName' => 'EUROPE',
                         },
                         {
                           'regionId'   => 'e102ba74-6764-47f3-8896-246141da8ada',
                           'regionName' => 'NORTH_AMERICA',
                         }
                      ]
                    }
                    response
                end
            end

            class Mock
                def get_all_regions(options = {})
                    data = self.data[:regions]
                    response        = Excon::Response.new
                    response.status = 200
                    response.body   = {
                      'getAllRegionsResponse' => self.data[:regions]
                    }
                    response
                end
            end
        end
    end
end