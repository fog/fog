module Fog
    module Compute
        class ProfitBricks
            class Real
                require 'fog/profitbricks/parsers/compute/delete_server'

                # Delete virtual server
                #
                # ==== Parameters
                # * serverId<~String> - UUID of the virtual server
                #
                # ==== Returns
                # * response<~Excon::Response>:
                #   * body<~Hash>:
                #     * deleteServerResponse<~Hash>:
                #       * requestId<~String> - ID of request
                #       * dataCenterId<~String> - UUID of virtual data center
                #       * dataCenterVersion<~Integer> - Version of the virtual data center
                #
                # {ProfitBricks API Documentation}[http://www.profitbricks.com/apidoc/DeleteServer.html]
                def delete_server(server_id)
                    soap_envelope = Fog::ProfitBricks.construct_envelope {
                      |xml| xml[:ws].deleteServer {
                        xml.serverId(server_id)
                      }
                    }

                    request(
                        :expects => [200],
                        :method  => 'POST',
                        :body    => soap_envelope.to_xml,
                        :parser  => 
                          Fog::Parsers::Compute::ProfitBricks::DeleteServer.new
                    )
                rescue Excon::Errors::InternalServerError => error
                    Fog::Errors::NotFound.new(error)
                end
            end

            class Mock
                def delete_server(server_id)

                    if server = self.data[:servers].find {
                      |attrib| attrib['serverId'] == server_id
                    }
                        self.data[:servers].delete(server)
                    else
                        raise Fog::Errors::NotFound.new(
                          'The requested server resource could not be found'
                        )
                    end

                    response        = Excon::Response.new
                    response.status = 200
                    response.body   = { 'deleteServerResponse' => {
                        'requestId'         => Fog::Mock::random_numbers(7),
                        'dataCenterId'      => Fog::UUID.uuid,
                        'dataCenterVersion' => 1,
                        }
                    }
                    response
                end
            end
        end
    end
end