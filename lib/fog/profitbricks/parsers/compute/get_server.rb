module Fog
    module Parsers
        module Compute
            module ProfitBricks
                class GetServer < Fog::Parsers::Base
                    def reset
                        @response = { 'getServerResponse' => {} }
                        @response['getServerResponse'] = {
                          'connectedStorages' => [],
                          'nics' => []
                        }
                        @storage = {}
                        @nic = {}
                    end

                    def end_element(name)
                        case name
                        when 'requestId', 'dataCenterId', 'dataCenterName',
                             'serverId', 'serverName', 'internetAccess',
                             'provisioningState', 'virtualMachineState',
                             'osType', 'availabilityZone', 'ips'
                            @response['getServerResponse'][name] = value
                        when 'dataCenterVersion', 'cores', 'ram'
                            @response['getServerResponse'][name] = value.to_i
                        when 'creationTime', 'lastModificationTime'
                            @response['getServerResponse'][name] = Time.parse(value)
                        when 'busType', 'storageId', 'storageName', 'bootDevice'
                            @storage[name] = value
                        when 'deviceNumber', 'size'
                            @storage[name] = value.to_i
                        when 'connectedStorages'
                            @response['getServerResponse']['connectedStorages'] << @storage
                        when 'nicId', 'nicName', 'macAddress', 'gatewayIp',
                             'dhcpActive', 'ips'
                            @nic[name] = value
                        when 'lanId'
                            @nic[name] = value.to_i
                        when 'nics'
                            @response['getServerResponse']['nics'] << @nic
                        end
                    end
                end
            end
        end
    end
end