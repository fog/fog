module Fog
    module Compute
        class ProfitBricks
            class Real
                require 'fog/profitbricks/parsers/compute/get_all_servers'
                # Retrieve list of virtual servers
                #
                # ==== Parameters
                # * N/A
                #
                # ==== Returns
                # * response<~Excon::Response>:
                #   * body<~Hash>:
                #     * getServerResponse<~Array>:
                #       * <~Hash>:
                #         * dataCenterId<~String> - UUID of virtual data center
                #         * dataCenterVersion<~Integer> - Version of the virtual data center
                #         * serverId<~String> - UUID of the new virtual server
                #         * serverName<~String> -
                #         * cores<~Integer> -
                #         * ram<~Integer> -
                #         * connectedStorages<~Array> -
                #         * nics<~Array> -
                #         * ips<~String> -
                #         * internetAccess<~Boolean> -
                #         * provisioningState<~String> -
                #         * virtualMachineState<~String> -
                #         * creationTime<~Time> -
                #         * lastModificationTime<~Time> -
                #         * osType<~String> - UNKNOWN, WINDOWS, LINUX, OTHER
                #         * availabilityZone<~String> - AUTO, ZONE_1, ZONE_2
                #
                # {ProfitBricks API Documentation}[http://www.profitbricks.com/apidoc/GetAllServers.html]
                def get_all_servers
                    soap_envelope = Fog::ProfitBricks.construct_envelope {
                      |xml| xml[:ws].getAllServers
                    }

                    request(
                        :expects => [200],
                        :method  => 'POST',
                        :body    => soap_envelope.to_xml,
                        :parser  => 
                          Fog::Parsers::Compute::ProfitBricks::GetAllServers.new
                    )
                end
            end

            class Mock
                def get_all_servers
                    response        = Excon::Response.new
                    response.status = 200
                    response.body   = { 'getAllServersResponse' => self.data[:servers] }
                    response
                end
            end
        end
    end
end