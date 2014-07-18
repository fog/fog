module Fog
    module Compute
        class ProfitBricks
            class Real
                def get_flavor(flavor_id)
                    response        = Excon::Response.new
                    response.status = 200
                    response.body   = {
                      'getFlavorResponse' => [
                        {
                          'id'    => '00db4c8f-5e83-49b0-a70b-ac4aad786163',
                          'name'  => 'Micro',
                          'ram'   => 1024,
                          'disk'  => 50,
                          'cores' => 1
                        },
                        {
                          'id'    => 'dc64957b-be9d-431e-91cd-9e217f94d3de',
                          'name'  => 'Small',
                          'ram'   => 2048,
                          'disk'  => 50,
                          'cores' => 1
                        },
                        {
                           'id'    => 'b37d000e-b347-4592-b572-df13ef8f68e1',
                           'name'  => 'Medium',
                           'ram'   => 4096,
                           'disk'  => 50,
                           'cores' => 2
                        },
                        {
                           'id'    => 'a5a4389f-54b6-4f47-b6e8-1c5c55976b94',
                           'name'  => 'Large',
                           'ram'   => 7168,
                           'disk'  => 50,
                           'cores' => 4
                        },
                        {
                           'id'    => '0052db40-f1dd-4ecf-a711-5980081b7059',
                           'name'  => 'Extra Large',
                           'ram'   => 14336,
                           'disk'  => 50,
                           'cores' => 8
                        },
                        {
                           'id'    => '8b2b835d-be09-48cf-aae2-7e35aafe92d6',
                           'name'  => 'Memory Intensive Small',
                           'ram'   => 16384,
                           'disk'  => 50,
                           'cores' => 2
                        },
                        {
                           'id'    => '45c28f8b-6a67-4f69-8c94-231d371da2b6',
                           'name'  => 'Memory Intensive Medium',
                           'ram'   => 28672,
                           'disk'  => 50,
                           'cores' => 4
                        },
                        {
                           'id'    => '1d22436d-d958-4151-b144-43a8e180c4c4',
                           'name'  => 'Memory Intensive Large',
                           'ram'   => 57344,
                           'disk'  => 50,
                           'cores' => 8
                        },
                      ].find { |flavor| flavor['id'] == flavor_id }
                    }
                    response
                end
            end

            class Mock
                def get_flavor(flavor_id)
                    response        = Excon::Response.new
                    response.status = 200

                    if flavor = self.data[:flavors].find {
                      |attrib| attrib['id'] == flavor_id
                    }
                    else
                        raise Fog::Errors::NotFound.new('The requested resource could not be found')
                    end

                    response.body = { 'getFlavorResponse' => flavor }
                    response
                end
            end
        end
    end
end