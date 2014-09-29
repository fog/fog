module Fog
    module Compute
        class ProfitBricks
            class Real
                def get_all_locations(options={})
                    response        = Excon::Response.new
                    response.status = 200
                    response.body   = {
                        'getAllLocationsResponse' => [
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
                        ]
                    }
                    response
                end
            end

            class Mock
                def get_all_locations(options={})
                    data = self.data[:regions]
                    response        = Excon::Response.new
                    response.status = 200
                    response.body   = {
                        'getAllLocationsResponse' => self.data[:regions]
                    }
                    response
                end
            end
        end
    end
end
