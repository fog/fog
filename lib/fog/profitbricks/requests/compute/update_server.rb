module Fog
    module Compute
        class ProfitBricks
            class Real
                require 'fog/profitbricks/parsers/compute/update_server'

                # Update a virtual server
                #
                # ==== Parameters
                # * serverId<~String> - Required, UUID of virtual server
                # * options<~Hash>:
                #   * serverName<~String> - Optional, 
                #   * cores<~Integer> - Optional,
                #   * ram<~Integer> Optional, Memory in MB
                #   * bootFromStorageId<~String> - Optional, UUID of boot storage
                #   * bootFromImageId<~String> -
                #   * osType<~String> - Optional, UNKNOWN, WINDOWS, LINUX, OTHER
                #   * availabilityZone<~String> - Optional, AUTO, ZONE_1, ZONE_2
                #
                # ==== Returns
                # * response<~Excon::Response>:
                #   * body<~Hash>:
                #     * updateServerResponse<~Hash>:
                #       * requestId<~String> - ID of request
                #       * dataCenterId<~String> - UUID of virtual data center
                #       * dataCenterVersion<~Integer> - Version of the virtual data center
                #
                # {ProfitBricks API Documentation}[http://www.profitbricks.com/apidoc/UpdateServer.html]
                def update_server(server_id, options={})
                    soap_envelope = Fog::ProfitBricks.construct_envelope {
                      |xml| xml[:ws].updateServer {
                        xml.request { 
                          xml.serverId(server_id)
                          options.each { |key, value| xml.send(key, value) }
                        }
                      }
                    }

                    request(
                        :expects => [200],
                        :method  => 'POST',
                        :body    => soap_envelope.to_xml,
                        :parser  =>
                          Fog::Parsers::Compute::ProfitBricks::UpdateServer.new
                    )
                rescue Excon::Errors::InternalServerError => error
                    Fog::Errors::NotFound.new(error)
                end
            end

            class Mock
                def update_server(server_id, options={})

                    if server = self.data[:servers].find {
                      |attrib| attrib['serverId'] == server_id
                    }
                        options.each do |key, value|
                            server[key] = value
                        end
                    else
                        raise Fog::Errors::NotFound.new(
                            'The requested server resource could not be found'
                        )
                    end

                    response        = Excon::Response.new
                    response.status = 200
                    response.body   = {
                      'updateServerResponse' =>
                      {
                        'requestId'         => Fog::Mock::random_numbers(7),
                        'dataCenterId'      => Fog::UUID.uuid,
                        'dataCenterVersion' => 1
                      }
                    }
                    response
                end
            end
        end
    end
end