module Fog
    module Parsers
        module Compute
            module ProfitBricks
                class UpdateStorage < Fog::Parsers::Base
                    def reset
                        @response = { 'updateStorageResponse' => {} }
                    end

                    def end_element(name)
                        case name
                        when 'requestId', 'dataCenterId'
                            @response['updateStorageResponse'][name] = value
                        when 'dataCenterVersion'
                            @response['updateStorageResponse'][name] = value.to_i
                        end
                    end
                end
            end
        end
    end
end