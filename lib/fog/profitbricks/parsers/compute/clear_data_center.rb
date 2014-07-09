module Fog
    module Parsers
        module Compute
            module ProfitBricks
                class ClearDataCenter < Fog::Parsers::Base
                    def reset
                        @response = {}
                    end

                    def end_element(name)
                        case name
                        when 'requestId', 'dataCenterId', 'dataCenterName',
                             'provisioningState', 'region'
                            @data_center[name] = value
                        when 'dataCenterVersion'
                            @data_center[name] = value.to_i
                        end
                    end
                end
            end
        end
    end
end
