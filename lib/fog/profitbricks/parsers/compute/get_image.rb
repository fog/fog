module Fog
    module Parsers
        module Compute
            module ProfitBricks
                class GetImage < Fog::Parsers::Base
                    def reset
                        @response = { 'getImageResponse' => {} }
                    end

                    def end_element(name)
                        case name
                        when 'imageId', 'imageName', 'imageType', 'writeable',
                             'cpuHotpluggable', 'memoryHotpluggable', 'region',
                             'osType', 'pubic', 'serverIds'
                            @response['getImageResponse'][name] = value
                        when 'imageSize'
                            @response['getImageResponse'][name] = value.to_i
                        end
                    end
                end
            end
        end
    end
end