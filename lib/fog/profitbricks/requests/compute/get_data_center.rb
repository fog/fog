module Fog
    module Compute
        class ProfitBricks
            class Real
                require 'fog/profitbricks/parsers/compute/get_data_center'
                def get_data_center(data_center_id)
                    soap_envelope = Fog::ProfitBricks.construct_envelope {
                      |xml| xml[:ws].getDataCenter {
                        xml.dataCenterId(data_center_id)
                      }
                    }

                    request(
                        :expects => [200],
                        :method  => 'POST',
                        :body    => soap_envelope.to_xml,
                        :parser  => 
                          Fog::Parsers::Compute::ProfitBricks::GetDataCenter.new
                    )
                rescue Excon::Errors::InternalServerError => error
                    Fog::Errors::NotFound.new(error)
                end
            end

            class Mock
                def get_data_center(data_center_id)
                    if dc = self.data[:datacenters].find {
                      |attrib| attrib['dataCenterId'] == data_center_id
                    }
                    else
                        raise Fog::Errors::NotFound.new('The requested resource could not be found')
                    end

                    response        = Excon::Response.new
                    response.status = 200
                    response.body   = { 'getDataCenterResponse' => dc }
                    response
                end
            end
        end
    end
end
