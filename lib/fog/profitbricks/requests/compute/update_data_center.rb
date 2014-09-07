module Fog
    module Compute
        class ProfitBricks
            class Real
                require 'fog/profitbricks/parsers/compute/update_data_center'
                def update_data_center(data_center_id, options={})
                    soap_envelope = Fog::ProfitBricks.construct_envelope {
                      |xml| xml[:ws].updateDataCenter {
                        xml.request { 
                          xml.dataCenterId(data_center_id)
                          options.each { |key, value| xml.send(key, value) }
                        }
                      }
                    }

                    request(
                        :expects => [200],
                        :method  => 'POST',
                        :body    => soap_envelope.to_xml,
                        :parser  => 
                          Fog::Parsers::Compute::ProfitBricks::UpdateDataCenter.new
                    )
                rescue Excon::Errors::InternalServerError => error
                    Fog::Errors::NotFound.new(error)
                end
            end

            class Mock
                def update_data_center(data_center_id, options={})

                    if data_center = self.data[:datacenters].find {
                      |attrib| attrib['dataCenterId'] == data_center_id
                    }
                        data_center['dataCenterName'] = options['dataCenterName']
                        data_center['dataCenterVersion'] += 1
                    else
                        raise Fog::Errors::NotFound.new('The requested resource could not be found')
                    end

                    response        = Excon::Response.new
                    response.status = 200
                    response.body   = {
                        'updateDataCenterResponse' =>
                        {
                            'requestId'         => Fog::Mock::random_numbers(7),
                            'dataCenterId'      => Fog::UUID.uuid,
                            'dataCenterVersion' => 1
                        }
                    }
                    response
                end
            end
        end
    end
end
