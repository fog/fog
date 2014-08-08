module Fog
    module Compute
        class ProfitBricks
            class Real
                require 'fog/profitbricks/parsers/compute/get_nic'

                # Return virtual NIC information
                #
                # ==== Parameters
                # * N/A
                #
                # ==== Returns
                # * response<~Excon::Response>:
                #   * body<~Hash>:
                #     * getNicResponse<~Hash>:
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
                # {ProfitBricks API Documentation}[http://www.profitbricks.com/apidoc/GetNIC.html]
                def get_nic(nic_id)
                    soap_envelope = Fog::ProfitBricks.construct_envelope {
                      |xml| xml[:ws].getNic {
                        xml.nicId(nic_id)
                      }
                    }

                    request(
                        :expects => [200],
                        :method  => 'POST',
                        :body    => soap_envelope.to_xml,
                        :parser  =>
                          Fog::Parsers::Compute::ProfitBricks::GetNic.new
                    )
                rescue Excon::Errors::InternalServerError => error
                    Fog::Errors::NotFound.new(error)
                end
            end

            class Mock
                def get_nic(nic_id)
                    if nic = self.data[:interfaces].find {
                      |attrib| attrib['nicId'] == nic_id
                    }
                    else
                        raise Fog::Errors::NotFound.new('The requested resource could not be found')
                    end

                    response        = Excon::Response.new
                    response.status = 200
                    response.body   = { 'getNicResponse' => nic }
                    response
                end
            end
        end
    end
end