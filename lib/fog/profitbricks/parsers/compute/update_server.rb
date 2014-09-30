module Fog
    module Parsers
        module Compute
            module ProfitBricks
                class UpdateServer < Fog::Parsers::Base
                    def reset
                        @response = { 'updateServerResponse' => {} }
                    end

                    def end_element(name)
                        case name
                        when 'requestId', 'dataCenterId'
                            @response['updateServerResponse'][name] = value
                        when 'dataCenterVersion'
                            @response['updateServerResponse'][name] = value.to_i
                        end
                    end
                end
            end
        end
    end
end