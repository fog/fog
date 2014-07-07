module Fog
    module Compute
        class ProfitBricks
            class Real
                def get_all_data_centers(options = {})
                    soap_envelope = Fog::ProfitBricks.construct_envelope { |xml| xml[:ws].getAllDataCenters }

                    request(
                        :expects => [200],
                        :method => 'POST',
                        :body => soap_envelope.to_xml
                    )
                end
            end

            class Mock
                def get_all_data_centers filters = {}
                end
            end
        end
    end
end
