module Fog
    module Parsers
        module Compute
            module ProfitBricks
                class UpdateDataCenter < Fog::Parsers::Base
                    def reset
                        @response = { 'updateDataCenterResponse' => {} }
                    end

                    def end_element(name)
                        case name
                        when 'requestId', 'dataCenterId'
                            @response['updateDataCenterResponse'][name] = value
                        when 'dataCenterVersion'
                            @response['updateDataCenterResponse'][name] = value.to_i
                        end
                    end
                end
            end
        end
    end
end