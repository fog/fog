module Fog
    module Compute
        class ProfitBricks
            class Real
                def get_location(location_id)
                    response        = Excon::Response.new
                    response.status = 200
                    response.body   = {
                        'getLocationResponse' => [
                            {
                                'locationId'   => 'c0420cc0-90e8-4f4b-8860-df0a07d18047',
                                'locationName' => 'de/fkb',
                                'country'      => 'DEU'
                            },
                            {
                                'locationId'   => '68c4099a-d9d8-4683-bdc2-12789aacfa2a',
                                'locationName' => 'de/fra',
                                'country'      => 'DEU'
                            },
                            {
                                'locationId'   => 'e102ba74-6764-47f3-8896-246141da8ada',
                                'locationName' => 'us/las',
                                'country'      => 'USA'
                            }
                        ].find { |location| location['locationId'] == location_id } || raise(Fog::Errors::NotFound)
                    }
                    response
                end
            end

            class Mock
                def get_location(location_id)
                    if location = self.data[:regions].find {
                        |attrib| attrib['locationId'] == location_id
                    }
                    else
                        raise Fog::Errors::NotFound.new('The requested resource could not be found')
                    end

                    response        = Excon::Response.new
                    response.status = 200
                    response.body   = { 'getLocationResponse' => location }
                    response
                end
            end
        end
    end
end