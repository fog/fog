module Fog
    module Compute
        class ProfitBricks
            class Real
                def get_all_flavors()
                    response        = Excon::Response.new
                    response.status = 200
                    response.body   = {
                        'getAllFlavorsResponse' => [
                            {
                                'flavorId'   => '00db4c8f-5e83-49b0-a70b-ac4aad786163',
                                'flavorName' => 'Micro',
                                'ram'        => 1024,
                                'cores'      => 1
                            },
                            {
                                'flavorId'   => 'dc64957b-be9d-431e-91cd-9e217f94d3de',
                                'flavorName' => 'Small',
                                'ram'        => 2048,
                                'cores'      => 1
                            },
                            {
                                'flavorId'   => 'b37d000e-b347-4592-b572-df13ef8f68e1',
                                'flavorName' => 'Medium',
                                'ram'        => 4096,
                                'cores'      => 2
                            },
                            {
                                'flavorId'   => 'a5a4389f-54b6-4f47-b6e8-1c5c55976b94',
                                'flavorName' => 'Large',
                                'ram'        => 7168,
                                'cores'      => 4
                            },
                            {
                                'flavorId'   => '0052db40-f1dd-4ecf-a711-5980081b7059',
                                'flavorName' => 'Extra Large',
                                'ram'        => 14336,
                                'cores'      => 8
                            },
                            {
                                'flavorId'   => '8b2b835d-be09-48cf-aae2-7e35aafe92d6',
                                'flavorName' => 'Memory Intensive Small',
                                'ram'        => 16384,
                                'cores'      => 2
                            },
                            {
                                'flavorId'   => '45c28f8b-6a67-4f69-8c94-231d371da2b6',
                                'flavorName' => 'Memory Intensive Medium',
                                'ram'        => 28672,
                                'cores'      => 4
                            },
                            {
                                'flavorId'    => '1d22436d-d958-4151-b144-43a8e180c4c4',
                                'flavorName'  => 'Memory Intensive Large',
                                'ram'         => 57344,
                                'cores'       => 8
                            },
                        ]
                    }
                    response
                end
            end

            class Mock
                def get_all_flavors
                    data = self.data[:flavors]
                    response        = Excon::Response.new
                    response.status = 200
                    response.body   = {
                        'getAllFlavorsResponse' => self.data[:flavors]
                    }
                    response
                end
            end
        end
    end
end
