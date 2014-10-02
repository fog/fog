module Fog
    module Parsers
        module Compute
            module ProfitBricks
                class DeleteStorage < Fog::Parsers::Base
                    def reset
                        @response = { 'deleteStorageResponse' => {} }
                    end

                    def end_element(name)
                        case name
                        when 'requestId', 'dataCenterId'
                            @response['deleteStorageResponse'][name] = value
                        when 'dataCenterVersion'
                            @response['deleteStorageResponse'][name] = value.to_i
                        end
                    end
                end
            end
        end
    end
end