module Fog
    module Parsers
        module Compute
            module ProfitBricks
                class GetAllImages < Fog::Parsers::Base
                    def reset
                        @image = {}
                        @response = { 'getAllImagesResponse' => [] }
                    end

                    def end_element(name)
                        case name
                        when 'imageId', 'imageName', 'imageType', 'writeable',
                             'cpuHotpluggable', 'memoryHotpluggable', 'region',
                             'osType', 'public', 'serverIds'
                            @image[name] = value
                        when 'imageSize'
                            @image[name] = value.to_i
                        when 'return'
                            @response['getAllImagesResponse'] << @image
                            @image = {}
                        end
                    end
                end
            end
        end
    end
end