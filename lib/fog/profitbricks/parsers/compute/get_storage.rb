module Fog
    module Parsers
        module Compute
            module ProfitBricks
                class GetStorage < Fog::Parsers::Base
                    def reset
                        @response = { 'getStorageResponse' => {} }
                        @response['getStorageResponse']['mountImage'] = {}
                    end

                    def end_element(name)
                        case name
                        when 'requestId', 'dataCenterId', 'storageId', 'storageName',
                             'serverIds', 'provisioningState'
                            @response['getStorageResponse'][name] = value
                        when 'imageId'
                            @response['getStorageResponse']['mountImage']['id'] = value
                        when 'imageName'
                            @response['getStorageResponse']['mountImage']['name'] = value
                        when 'dataCenterVersion', 'size'
                            @response['getStorageResponse'][name] = value.to_i
                        when 'creationTime', 'lastModificationTime'
                            @response['getStorageResponse'][name] = Time.parse(value)
                        end
                    end
                end
            end
        end
    end
end