module Fog
    module Compute
        class ProfitBricks
            class Real
                require 'fog/profitbricks/parsers/compute/get_all_data_centers'
                def get_all_data_centers(options = {})
                    soap_envelope = Fog::ProfitBricks.construct_envelope {
                      |xml| xml[:ws].getAllDataCenters
                    }

                    request(
                        :expects => [200],
                        :method  => 'POST',
                        :body    => soap_envelope.to_xml,
                        :parser  => Fog::Parsers::Compute::ProfitBricks::GetAllDataCenters.new
                    )
                end
            end

            class Mock
                def get_all_data_centers(filters = {})
                    Fog::Mock::not_implemented
                end
            end
        end
    end
end
