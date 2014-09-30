module Fog
    module Compute
        class ProfitBricks
            class Real
                # Not a real API method; will only return flavor object.
                def create_flavor(flavor_name, cores, ram)
                    response        = Excon::Response.new
                    response.status = 200
                    response.body   = {
                      'createFlavorResponse' => {
                          'id'    => Fog::UUID.uuid,
                          'name'  => flavor_name,
                          'cores' => cores,
                          'ram'   => ram,
                      }
                    }
                    response
                end
            end

            class Mock
                def create_flavor(flavor_name, ram, cores)
                    response = Excon::Response.new
                    response.status = 200
                    
                    flavor = {
                      'id'    => Fog::UUID.uuid,
                      'name'  => flavor_name,
                      'ram'   => ram,
                      'cores' => cores
                    }
                    
                    self.data[:flavors] << flavor
                    response.body = { 'createFlavorResponse' => flavor }
                    response
                end
            end
        end
    end
end