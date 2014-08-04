module Fog
    module Compute
        class ProfitBricks
            class Real
                require 'fog/profitbricks/parsers/compute/reset_server'

                # Reset specified virtual server
                #
                # ==== Parameters
                # * serverId<~String> - UUID of a virtual server
                #
                # ==== Returns
                # * response<~Excon::Response>:
                #   * body<~Hash>:
                #     * resetServerResponse<~Hash>:
                #       * requestId<~String> - ID of request
                #
                # {ProfitBricks API Documentation}[http://www.profitbricks.com/apidoc/ResetServer.html]
                def reset_server(server_id)
                    soap_envelope = Fog::ProfitBricks.construct_envelope {
                      |xml| xml[:ws].resetServer {
                        xml.serverId(server_id)
                      }
                    }

                    request(
                        :expects => [200],
                        :method  => 'POST',
                        :body    => soap_envelope.to_xml,
                        :parser  => 
                          Fog::Parsers::Compute::ProfitBricks::ResetServer.new
                    )
                rescue Excon::Errors::InternalServerError => error
                    Fog::Errors::NotFound.new(error)
                end
            end

            class Mock
                def reset_server(server_id)
                    response        = Excon::Response.new
                    response.status = 200
                    response.body   = { 'resetServerResponse' =>
                      { 'requestId' => Fog::Mock::random_numbers(7) }
                    }
                    response
                end
            end
        end
    end
end