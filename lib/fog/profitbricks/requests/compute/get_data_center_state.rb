module Fog
    module Compute
        class ProfitBricks
            class Real
                require 'fog/profitbricks/parsers/compute/get_data_center_state'
                def get_data_center_state(data_center_id)
                    soap_envelope = Fog::ProfitBricks.construct_envelope {
                      |xml| xml[:ws].getDataCenterState {
                        xml.dataCenterId(data_center_id)
                      }
                    }

                    request(
                        :expects => [200],
                        :method  => 'POST',
                        :body    => soap_envelope.to_xml,
                        :parser  => 
                          Fog::Parsers::Compute::ProfitBricks::GetDataCenterState.new
                    )
                end
            end

            class Mock
                def get_data_center_state(data_center_id)
                    if data = self.data[:datacenters]
                        dc = self.data[:datacenters].find {
                          |attrib| attrib['dataCenterId'] == data_center_id
                        }

                        response        = Excon::Response.new
                        response.status = 200
                        response.body   = { 'getDataCenterStateResponse' =>
                          { 'return' => dc['provisioningState'] }
                        }
                        response
                    else
                        raise Fog::Compute::NotFound
                    end
                end
            end
        end
    end
end
