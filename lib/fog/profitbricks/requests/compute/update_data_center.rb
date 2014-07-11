module Fog
    module Compute
        class ProfitBricks
            class Real
                require 'fog/profitbricks/parsers/compute/update_data_center'
                def update_data_center(data_center_id, data_center_name='')
                    soap_envelope = Fog::ProfitBricks.construct_envelope {
                      |xml| xml[:ws].updateDataCenter {
                        xml.request { 
                          xml.dataCenterId(data_center_id)
                          xml.dataCenterName(data_center_name)
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
                end
            end

            class Mock
                def update_data_center(data_center_id)
                    Fog::Mock::not_implemented
                end
            end
        end
    end
end
