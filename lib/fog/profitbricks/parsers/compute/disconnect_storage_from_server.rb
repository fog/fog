module Fog
    module Parsers
        module Compute
            module ProfitBricks
                class DisconnectStorageFromServer < Fog::Parsers::Base
                    def reset
                        @response = { 'disconnectStorageFromServerResponse' => {} }
                    end

                    def end_element(name)
                        case name
                        when 'requestId', 'dataCenterId'
                            @response['disconnectStorageFromServerResponse'][name] = value
                        when 'dataCenterVersion'
                            @response['disconnectStorageFromServerResponse'][name] = value.to_i
                        end
                    end
                end
            end
        end
    end
end