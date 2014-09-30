module Fog
    module Parsers
        module Compute
            module ProfitBricks
                class DeleteServer < Fog::Parsers::Base
                    def reset
                        @response = { 'deleteServerResponse' => {} }
                    end

                    def end_element(name)
                        case name
                        when 'requestId', 'dataCenterId'
                            @response['deleteServerResponse'][name] = value
                        when 'dataCenterVersion'
                            @response['deleteServerResponse'][name] = value.to_i
                        end
                    end
                end
            end
        end
    end
end