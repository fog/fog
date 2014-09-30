module Fog
    module Parsers
        module Compute
            module ProfitBricks
                class CreateNic < Fog::Parsers::Base
                    def reset
                        @response = { 'createNicResponse' => {} }
                    end

                    def end_element(name)
                        case name
                        when 'requestId', 'dataCenterId', 'nicId'
                            @response['createNicResponse'][name] = value
                        when 'dataCenterVersion'
                            @response['createNicResponse'][name] = value.to_i
                        end
                    end
                end
            end
        end
    end
end