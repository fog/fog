module Fog
    module Parsers
        module Compute
            module ProfitBricks
                class GetNic < Fog::Parsers::Base
                    def reset
                        @response = { 'getNicResponse' => {} }
                        @response['getNicResponse']['firewall'] = {}
                    end

                    def end_element(name)
                        case name
                        when 'dataCenterId', 'nicId', 'nicName', 'serverId',
                             'internetAccess', 'serverId', 'ips', 'macAddress',
                             'dhcpActive', 'gatewayIp', 'provisioningState'
                            @response['getNicResponse'][name] = value
                        when 'dataCenterVersion', 'lanId'
                            @response['getNicResponse'][name] = value.to_i
                        when 'active', 'firewallId', 'firewallRules'
                            @response['getNicResponse']['firewall'][name] = value
                        end
                    end
                end
            end
        end
    end
end