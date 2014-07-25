module Fog
    module Parsers
        module Compute
            module ProfitBricks
                class ResetServer < Fog::Parsers::Base
                    def reset
                        @response = { 'resetServerResponse' => {} }
                    end

                    def end_element(name)
                        case name
                        when 'serverId'
                            @response['resetServerResponse'][name] = value.to_i
                        end
                    end
                end
            end
        end
    end
end