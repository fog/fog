module Fog
    module Parsers
        module Compute
            module ProfitBricks
                class CreateDataCenter < Fog::Parsers::Base
                    def reset
                        @response = { 'createDataCenterResponse' => {} }
                    end

                    def end_element(name)
                        case name
                        when 'requestId', 'dataCenterId', 'location'
                            @response['createDataCenterResponse'][name] = value
                        when 'dataCenterVersion'
                            @response['createDataCenterResponse'][name] = value.to_i
                        end
                    end
                end
            end
        end
    end
end