module Fog
    module Parsers
        module Compute
            module ProfitBricks
                class GetAllDataCenters < Fog::Parsers::Base
                    def reset
                        @datacenter = {}
                        @response = { 'getAllDataCentersResponse' => [] }
                    end

                    def end_element(name)
                        case name
                        when 'dataCenterId', 'dataCenterName'
                            @datacenter[name] = value
                        when 'dataCenterVersion'
                            @datacenter[name] = value.to_i
                        when 'return'
                            @response['getAllDataCentersResponse'] << @datacenter
                            @datacenter = {}
                        end
                    end
                end
            end
        end
    end
end