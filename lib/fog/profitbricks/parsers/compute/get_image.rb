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
                             'osType', 'pubic', 'serverIds', 'cpuHotPlug', 'public',
                             'cpuHotUnPlug', 'ramHotPlug', 'ramHotUnPlug', 'bootable',
                             'discVirtioHotPlug', 'discVirtioHotUnPlug', 'location',
                             'nicHotPlug', 'nicHotUnPlug', 'description'
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