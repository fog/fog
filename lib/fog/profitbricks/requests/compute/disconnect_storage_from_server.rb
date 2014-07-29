module Fog
    module Compute
        class ProfitBricks
            class Real
                require 'fog/profitbricks/parsers/compute/disconnect_storage_from_server'

                # Disconnect virtual storage
                #
                # ==== Parameters
                # * serverId<~String> - UUID of virtual server
                # * storageId<~String> - UUID of virtual storage
                #
                # ==== Returns
                # * response<~Excon::Response>:
                #   * body<~Hash>:
                #     * disconnectStorageToServerResponse<~Hash>:
                #       * requestId<~String> - ID of request
                #       * dataCenterId<~String> - UUID of virtual data center
                #       * dataCenterVersion<~Integer> - Version of the virtual data center
                #
                # {ProfitBricks API Documentation}[http://www.profitbricks.com/apidoc/APIDocumentation.html?disconnectStorageToServer.html]
                def disconnect_storage_from_server(server_id, storage_id)
                    soap_envelope = Fog::ProfitBricks.construct_envelope {
                      |xml| xml[:ws].disconnectStorageFromServer {
                          xml.serverId(server_id)
                          xml.storageId(storage_id)
                      }
                    }

                    request(
                        :expects => [200],
                        :method  => 'POST',
                        :body    => soap_envelope.to_xml,
                        :parser  => 
                          Fog::Parsers::Compute::ProfitBricks::DisconnectStorageFromServer.new
                    )
                rescue Excon::Errors::InternalServerError => error
                    Fog::Errors::NotFound.new(error)
                end
            end

            class Mock
                def disconnect_storage_from_server(server_id, storage_id)
                    response = Excon::Response.new
                    response.status = 200
                    
                    unless storage = self.data[:volumes].find {
                      |attrib| attrib['id'] == storage_id
                    }
                        raise Fog::Errors::NotFound.new(
                          'The requested storage resource could not be found'
                        )
                    end

                    if server = self.data[:servers].find {
                      |attrib| attrib['id'] == server_id
                    }['connectedStorages'].delete(storage)
                    else
                        raise Fog::Errors::NotFound.new(
                          'The requested server resource could not be found'
                        )
                    end
                    
                    response.body =
                    { 'disconnectStorageFromServerResponse' =>
                      {
                        'requestId' => Fog::Mock::random_numbers(7),
                        'dataCenterId' => Fog::UUID.uuid,
                        'dataCenterVersion' => 1
                      }
                    }
                    response
                end
            end
        end
    end
end