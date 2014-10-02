module Fog
    module Parsers
        module Compute
            module ProfitBricks
                class GetAllNic < Fog::Parsers::Base
                    def reset
                        @nic = { 'firewall' => {} }
                        @response = { 'getAllNicResponse' => [] }
                    end

                    def end_element(name)
                        case name
                        when 'dataCenterId', 'nicId', 'nicName', 'serverId',
                             'internetAccess', 'serverId', 'ips', 'macAddress',
                             'dhcpActive', 'gatewayIp', 'provisioningState'
                            @nic[name] = value
                        when 'dataCenterVersion', 'lanId'
                            @nic[name] = value.to_i
                        when 'active', 'firewallId', 'firewallRules'
                            @nic['firewall'][name] = value
                        when 'return'
                            @response['getAllNicResponse'] << @nic
                            @nic = { 'firewall' => {} }
                        end
                    end
                end
            end
        end
    end
end