module Fog
    module Parsers
        module Compute
            module ProfitBricks
                class GetAllStorages < Fog::Parsers::Base
                    def reset
                        @storage = { 'mountImage' => {} }
                        @response = { 'getAllStoragesResponse' => [] }
                    end

                    def end_element(name)
                        case name
                        when 'dataCenterId', 'storageId', 'storageName',
                             'serverIds', 'provisioningState'
                            @storage[name] = value
                        when 'imageId'
                            @storage['mountImage']['id'] = value
                        when 'imageName'
                            @storage['mountImage']['name'] = value
                        when 'dataCenterVersion', 'size'
                            @storage[name] = value.to_i
                        when 'creationTime', 'lastModificationTime'
                            @storage[name] = Time.parse(value)
                        when 'return'
                            @response['getAllStoragesResponse'] << @storage
                            @storage = { 'mountImage' => {} }
                        end
                    end
                end
            end
        end
    end
end