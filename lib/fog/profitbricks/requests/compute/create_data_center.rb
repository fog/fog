module Fog
    module Compute
        class ProfitBricks
            class Real
                require 'fog/profitbricks/parsers/compute/create_data_center'
                def create_data_center(data_center_name, region='')
                    soap_envelope = Fog::ProfitBricks.construct_envelope {
                      |xml| xml[:ws].createDataCenter {
                        xml.dataCenterName(data_center_name)
                        xml.region(region)
                      }
                    }

                    request(
                        :expects => [200],
                        :method  => 'POST',
                        :body    => soap_envelope.to_xml,
                        :parser  => 
                          Fog::Parsers::Compute::ProfitBricks::CreateDataCenter.new
                    )
                end
            end

            class Mock
                def create_data_center(create_center_name, region='')
                    Fog::Mock::not_implemented
                end
            end
        end
    end
end
