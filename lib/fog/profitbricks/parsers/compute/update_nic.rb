module Fog
    module Parsers
        module Compute
            module ProfitBricks
                class UpdateNic < Fog::Parsers::Base
                    def reset
                        @response = { 'updateNicResponse' => {} }
                    end

                    def end_element(name)
                        case name
                        when 'requestId', 'dataCenterId'
                            @response['updateNicResponse'][name] = value
                        when 'dataCenterVersion'
                            @response['updateNicResponse'][name] = value.to_i
                        end
                    end
                end
            end
        end
    end
end