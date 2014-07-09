module Fog
    module Parsers
        module Compute
            module ProfitBricks
                class GetAllDataCenters < Fog::Parsers::Base
                    def reset
                        @data_center = {}
                        @response = { 'getAllDataCentersResponse' => [] }
                        #@response = { 'getAllDataCentersResponse' => [] }
                    end

                    def end_element(name)
                        case name
                        when 'dataCenterId', 'dataCenterName'
                            @data_center[name] = value
                        when 'dataCenterVersion'
                            @data_center[name] = value.to_i
                        when 'return'
                            @response['data_centers'] << @data_center
                            @data_center = {}
                        end
                    end
                end
            end
        end
    end
end
