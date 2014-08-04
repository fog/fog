module Fog
    module Compute
        class ProfitBricks
            class Real
                def get_region(region_id)
                    response        = Excon::Response.new
                    response.status = 200
                    response.body   = {
                      'getRegionResponse' => [
                         {
                           'regionId'   => 'c0420cc0-90e8-4f4b-8860-df0a07d18047',
                           'regionName' => 'EUROPE',
                         },
                         {
                           'regionId'   => 'e102ba74-6764-47f3-8896-246141da8ada',
                           'regionName' => 'NORTH_AMERICA',
                         }
                      ].find { |region| region['regionId'] == region_id }
                    }
                    response
                end
            end

            class Mock
                def get_region(region_id)
                    if region = self.data[:regions].find {
                      |attrib| attrib['regionId'] == region_id
                    }
                    else
                        raise Fog::Errors::NotFound.new('The requested resource could not be found')
                    end

                    response        = Excon::Response.new
                    response.status = 200
                    response.body   = { 'getRegionResponse' => region }
                    response
                end
            end
        end
    end
end