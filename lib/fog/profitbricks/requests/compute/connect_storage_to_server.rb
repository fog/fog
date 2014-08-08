module Fog
    module Compute
        class ProfitBricks
            class Real
                require 'fog/profitbricks/parsers/compute/connect_storage_to_server'

                # Connect virtual storage
                #
                # ==== Parameters
                # * storageId<~String> - Required, UUID of virtual storage
                # * serverId<~String> - Required, 
                # * options<~Hash>:
                #   * busType<~String> - Optional, VIRTIO, IDE 
                #   * deviceNumber<~Integer> - Optional, 
                #
                # ==== Returns
                # * response<~Excon::Response>:
                #   * body<~Hash>:
                #     * connectStorageToServerResponse<~Hash>:
                #       * requestId<~String> - ID of request
                #       * dataCenterId<~String> - UUID of virtual data center
                #       * dataCenterVersion<~Integer> - Version of the virtual data center
                #
                # {ProfitBricks API Documentation}[http://www.profitbricks.com/apidoc/ConnectStorage.html]
                def connect_storage_to_server(storage_id, server_id, options={})
                    soap_envelope = Fog::ProfitBricks.construct_envelope {
                      |xml| xml[:ws].connectStorageToServer {
                        xml.request { 
                          xml.storageId(storage_id)
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
                          Fog::Parsers::Compute::ProfitBricks::ConnectStorageToServer.new
                    )
                rescue Excon::Errors::InternalServerError => error
                    Fog::Errors::NotFound.new(error)
                end
            end

            class Mock
                def connect_storage_to_server(storage_id, server_id, options={})

                    if storage = self.data[:volumes].find {
                        |attrib| attrib['storageId'] == storage_id
                    }
                    else
                        raise Fog::Errors::NotFound.new(
                            'The requested volume could not be found'
                        )
                    end

                    if server = self.data[:servers].find {
                        |attrib| attrib['serverId'] == server_id
                    }
                        server['connectedStorages'] << storage
                    else
                        raise Fog::Errors::NotFound.new(
                            'The requested server could not be found'
                        )
                    end

                    response = Excon::Response.new
                    response.status = 200
                    response.body =
                    { 'connectStorageToServerResponse' =>
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