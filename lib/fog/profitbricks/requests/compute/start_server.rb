module Fog
    module Compute
        class ProfitBricks
            class Real
                #require 'fog/profitbricks/parsers/compute/start_server'

                # Start specified virtual server
                #
                # ==== Parameters
                # * serverId<~String> - UUID of a virtual server
                #
                # ==== Returns
                # * response<~Excon::Response>:
                #   * body<~Hash>:
                #     * startServerResponse<~Hash>:
                #       * requestId<~String> - ID of request
                #
                # {ProfitBricks API Documentation}[http://www.profitbricks.com/apidoc/StartServer.html]
                def start_server(server_id)
                    soap_envelope = Fog::ProfitBricks.construct_envelope {
                      |xml| xml[:ws].startServer {
                        xml.serverId(server_id)
                      }
                    }

                    request(
                        :expects => [200],
                        :method  => 'POST',
                        :body    => soap_envelope.to_xml,
                        #:parser  => 
                        #  Fog::Parsers::Compute::ProfitBricks::StartServer.new
                    )
                rescue Excon::Errors::InternalServerError => error
                    Fog::Errors::NotFound.new(error)
                end
            end

            class Mock
                def start_server(server_id)

                    if server = self.data[:servers].find {
                      |attrib| attrib['serverId'] == server_id
                    }
                        server['machine_state'] = 'RUNNING'
                        server['provisioning_state'] = 'AVAILABLE'
                    else
                        raise Fog::Errors::NotFound.new('The requested server resource could not be found')
                    end

                    response        = Excon::Response.new
                    response.status = 200
                    response.body   = { 'startServerResponse' =>
                      { 'requestId' => Fog::Mock::random_numbers(7) }
                    }
                    response
                end
            end
        end
    end
end