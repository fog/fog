module Fog
    module Parsers
        module Compute
            module ProfitBricks
                class DeleteDataCenter < Fog::Parsers::Base
                    def reset
                        @response = { 'deleteDataCenterResponse' => {} }
                    end

                    def end_element(name)
                        case name
                        when 'requestId'
                            @response['deleteDataCenterResponse'][name] = value
                        end
                    end
                end
            end
        end
    end
end
