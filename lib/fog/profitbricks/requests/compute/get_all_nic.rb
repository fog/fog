module Fog
    module Compute
        class ProfitBricks
            class Real
                require 'fog/profitbricks/parsers/compute/get_all_nic'

                # Returns all virtual NICs
                #
                # ==== Parameters
                # * N/A
                #
                # ==== Returns
                # * response<~Excon::Response>:
                #   * body<~Hash>:
                #     * getAllNicResponse<~Hash>:
                #       * nicId<~String> - UUID of the network interface
                #       * nicName<~String> - Name of the network interface
                #       * lanId<~Integer> - 
                #       * internetAccess<~Boolean> - 
                #       * serverId<~String> - 
                #       * ips<~String> - 
                #       * macAddress<~String> - 
                #       * firewall<~Hash>:
                #         * ... 
                #       * dhcpActive<~Boolean> - 
                #       * gatewayIp<~String> - 
                #       * provisioningState<~String> - INACTIVE, INPROCESS, AVAILABLE, DELETED, ERROR
                #
                # {ProfitBricks API Documentation}[http://www.profitbricks.com/apidoc/GetAllNIC.html]
                def get_all_nic
                    soap_envelope = Fog::ProfitBricks.construct_envelope {
                      |xml| xml[:ws].getAllNic
                    }

                    request(
                        :expects => [200],
                        :method  => 'POST',
                        :body    => soap_envelope.to_xml,
                        :parser  => 
                          Fog::Parsers::Compute::ProfitBricks::GetAllNic.new
                    )
                end
            end

            class Mock
                def get_all_nic
                    response        = Excon::Response.new
                    response.status = 200
                    response.body   = { 'getAllNicResponse' => self.data[:interfaces] }
                    response
                end
            end
        end
    end
end