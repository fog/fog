module Fog
    module Parsers
        module Compute
            module ProfitBricks
                class ConnectStorageToServer < Fog::Parsers::Base
                    def reset
                        @response = { 'connectStorageToServerResponse' => {} }
                    end

                    def end_element(name)
                        case name
                        when 'requestId', 'dataCenterId'
                            @response['connectStorageToServerResponse'][name] = value
                        when 'dataCenterVersion'
                            @response['connectStorageToServerResponse'][name] = value.to_i
                        end
                    end
                end
            end
        end
    end
end