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
                             'osType', 'availabilityZone', 'ips'
                            @server[name] = value
                        when 'dataCenterVersion', 'cores', 'ram'
                            @server[name] = value.to_i
                        when 'creationTime', 'lastModificationTime'
                            @server[name] = Time.parse(value)
                        when 'busType', 'storageId', 'storageName', 'bootDevice'
                            @storage[name] = value
                        when 'deviceNumber', 'size'
                            @storage[name] = value.to_i
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
                            @server = {}
                        end
                    end
                end
            end
        end
    end
end