module Fog
    module Compute
        class ProfitBricks
            class Real
                require 'fog/profitbricks/parsers/compute/delete_data_center'
                def delete_data_center(data_center_id)
                    soap_envelope = Fog::ProfitBricks.construct_envelope {
                      |xml| xml[:ws].deleteDataCenter {
                        xml.dataCenterId(data_center_id)
                      }
                    }

                    request(
                        :expects => [200],
                        :method  => 'POST',
                        :body    => soap_envelope.to_xml,
                        :parser  => 
                          Fog::Parsers::Compute::ProfitBricks::DeleteDataCenter.new
                    )
                end
            end

            class Mock
                def delete_data_center(data_center_id)
                    Fog::Mock::not_implemented
                end
            end
        end
    end
end
