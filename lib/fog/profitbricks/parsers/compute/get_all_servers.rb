module Fog
    module Parsers
        module Compute
            module ProfitBricks
                class GetAllServers < Fog::Parsers::Base
                    def reset
                        @response = { 'getAllServersResponse' => [] }
                        @server = { 'connectedStorages' => [], 'nics' => [] }
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
                            @server[name] = value
                        when 'dataCenterVersion', 'cores', 'ram'
                            @server[name] = value.to_i
                        when 'creationTime', 'lastModificationTime'
                            @server[name] = Time.parse(value)
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
                            @server['connectedStorages'] << @storage
                        when 'nicId', 'nicName', 'macAddress', 'gatewayIp',
                             'dhcpActive', 'ips'
                            @nic[name] = value
                        when 'lanId'
                            @nic[name] = value.to_i
                        when 'nics'
                            @server['nics'] << @nic
                        when 'return'
                            @response['getAllServersResponse'] << @server
                            @server = { 'connectedStorages' => [], 'nics' => [] }
                        end
                    end
                end
            end
        end
    end
end