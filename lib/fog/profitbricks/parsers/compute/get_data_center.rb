module Fog
    module Parsers
        module Compute
            module ProfitBricks
                class GetDataCenter < Fog::Parsers::Base
                    def reset
                        @response = { 'getDataCenterResponse' => {} }
                    end

                    def end_element(name)
                        case name
                        when 'requestId', 'dataCenterId', 'dataCenterName',
                             'provisioningState', 'location'
                            @response['getDataCenterResponse'][name] = value
                        when 'dataCenterVersion'
                            @response['getDataCenterResponse'][name] = value.to_i
                        end
                    end
                end
            end
        end
    end
end