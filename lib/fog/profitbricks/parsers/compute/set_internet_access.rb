module Fog
    module Parsers
        module Compute
            module ProfitBricks
                class SetInternetAccess < Fog::Parsers::Base
                    def reset
                        @response = { 'setInternetAccessResponse' => {} }
                    end

                    def end_element(name)
                        case name
                        when 'requestId', 'dataCenterId'
                            @response['setInternetAccessResponse'][name] = value
                        when 'dataCenterVersion'
                            @response['setInternetAccessResponse'][name] = value.to_i
                        end
                    end
                end
            end
        end
    end
end