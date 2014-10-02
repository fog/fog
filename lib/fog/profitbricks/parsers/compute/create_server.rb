module Fog
    module Parsers
        module Compute
            module ProfitBricks
                class CreateServer < Fog::Parsers::Base
                    def reset
                        @response = { 'createServerResponse' => {} }
                    end

                    def end_element(name)
                        case name
                        when 'requestId', 'dataCenterId', 'serverId'
                            @response['createServerResponse'][name] = value
                        when 'dataCenterVersion'
                            @response['createServerResponse'][name] = value.to_i
                        end
                    end
                end
            end
        end
    end
end