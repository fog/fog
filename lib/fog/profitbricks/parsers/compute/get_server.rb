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
                             'osType', 'availabilityZone', 'ips', 'cpuHotPlug',
                             'ramHotPlug', 'nicHotPlug', 'nicHotUnPlug',
                             'discVirtioHotPlug', 'discVirtioHotUnPlug'
                            @response['getServerResponse'][name] = value
                        when 'dataCenterVersion', 'cores', 'ram'
                            @response['getServerResponse'][name] = value.to_i
                        when 'creationTime', 'lastModificationTime'
                            @response['getServerResponse'][name] = Time.parse(value)
                        when 'storageId'
                            @storage['id'] = value
                        when 'storageName'
                            @storage['name'] = value
                        when 'busType'
                            @storage['bus_type'] = value
                        when 'bootDevice'
                            @storage['boot_device'] = value
                        when 'deviceNumber'
                            @storage['device_number'] = value.to_i
                        when 'size'
                            @storage['size'] = value.to_i
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