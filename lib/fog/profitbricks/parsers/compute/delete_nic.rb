module Fog
    module Parsers
        module Compute
            module ProfitBricks
                class DeleteNic < Fog::Parsers::Base
                    def reset
                        @response = { 'deleteNicResponse' => {} }
                    end

                    def end_element(name)
                        case name
                        when 'requestId', 'dataCenterId'
                            @response['deleteNicResponse'][name] = value
                        when 'dataCenterVersion'
                            @response['deleteNicResponse'][name] = value.to_i
                        end
                    end
                end
            end
        end
    end
end