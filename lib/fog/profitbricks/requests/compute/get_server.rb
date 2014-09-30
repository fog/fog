module Fog
    module Compute
        class ProfitBricks
            class Real
                require 'fog/profitbricks/parsers/compute/get_server'

                # Create new virtual server
                #
                # ==== Parameters
                # * serverId<~String> - UUID of a virtual server
                #
                # ==== Returns
                # * response<~Excon::Response>:
                #   * body<~Hash>:
                #     * getServerResponse<~Hash>:
                #       * requestId<~String> - ID of request
                #       * dataCenterId<~String> - UUID of virtual data center
                #       * dataCenterVersion<~Integer> - Version of the virtual data center
                #       * serverId<~String> - UUID of the new virtual server
                #       * serverName<~String> -
                #       * cores<~Integer> -
                #       * ram<~Integer> -
                #       * internetAccess<~String> -
                #       * ips<~String> -
                #       * connectedStorages<~Array>:
                #         * bootDevice<~Integer> -
                #         * busType<~String> - VIRTIO|IDE
                #         * deviceNumber<~Integer> -
                #         * size<~Integer> -
                #         * storageId<~String> -
                #         * storageName<~String> -
                #       * nics<~Array>:
                #         * dataCenterId<~String> -
                #         * dataCenterVersion<~Integer> -
                #         * nicId<~String> -
                #         * lanId<~Integer> -
                #         * internetAccess<~String> -
                #         * serverId<~String> -
                #         * ips<~String> -
                #         * macAddress<~String> -
                #         * firewall<~Hash>:
                #           * active<~String> -
                #           * firewallId<~String> -
                #           * nicId<~String> -
                #           * provisioningState<~String> -
                #         * dhcpActive<~String> -
                #         * provisioningState<~String> -
                #       * provisioningState<~String> -
                #       * virtualMachineState<~String> -
                #       * creationTime<~Time> -
                #       * lastModificationTime<~Time> -
                #       * osType<~String> -
                #       * availabilityZone<~String> -
                #       * cpuHotPlug<~String> -
                #       * ramHotPlug<~String> -
                #       * nicHotPlug<~String> -
                #       * nicHotUnPlug<~String> -
                #       * discVirtioHotPlug<~String> -
                #       * discVirtioHotUnPlug<~String> -
                #
                # {ProfitBricks API Documentation}[http://www.profitbricks.com/apidoc/APIDocumentation.html?getServer.html]
                def get_server(server_id)
                    soap_envelope = Fog::ProfitBricks.construct_envelope {
                      |xml| xml[:ws].getServer {
                        xml.serverId(server_id)
                      }
                    }

                    request(
                        :expects => [200],
                        :method  => 'POST',
                        :body    => soap_envelope.to_xml,
                        :parser  => 
                          Fog::Parsers::Compute::ProfitBricks::GetServer.new
                    )
                rescue Excon::Errors::InternalServerError => error
                    Fog::Errors::NotFound.new(error)
                end
            end

            class Mock
                def get_server(server_id)

                    if server = self.data[:servers].find {
                      |attrib| attrib['serverId'] == server_id
                    }
                    else
                        raise Fog::Errors::NotFound.new('The server resource could not be found')
                    end

                    server['requestId'] = Fog::Mock::random_numbers(7)

                    response        = Excon::Response.new
                    response.status = 200
                    response.body   = { 'getServerResponse' => server }
                    response
                end
            end
        end
    end
end