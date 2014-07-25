module Fog
    module Compute
        class ProfitBricks
            class Real
                require 'fog/profitbricks/parsers/compute/connect_storage_to_server'

                # Connect virtual storage
                #
                # ==== Parameters
                # * busType<~String> - 
                # * deviceNumber<~String> -
                # * storageId<~String> - UUID of virtual storage
                # * serverId<~String> -
                #
                # ==== Returns
                # * response<~Excon::Response>:
                #   * body<~Hash>:
                #     * connectStorageToServerResponse<~Hash>:
                #       * requestId<~String> - ID of request
                #       * dataCenterId<~String> - UUID of virtual data center
                #       * dataCenterVersion<~Integer> - Version of the virtual data center
                #
                # {ProfitBricks API Documentation}[http://www.profitbricks.com/apidoc/APIDocumentation.html?connectStorageToServer.html]
                def connect_storage_to_server(bus_type='VIRTIO', device_number='',
                                              storage_id, server_id)
                    soap_envelope = Fog::ProfitBricks.construct_envelope {
                      |xml| xml[:ws].connectStorageToServer {
                        xml.request { 
                          xml.busType(bus_type)
                          xml.deviceNumber(device_number)
                          xml.storageId(storage_id)
                          xml.serverId(server_id)
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
                def connect_storage_to_server(bus_type='VIRTIO', device_number='',
                                              storage_id, server_id)
                    response = Excon::Response.new
                    response.status = 200

                    if storage = self.data[:volumes].find {
                      |attrib| attrib['id'] == storage_id
                    }
                        if server = self.data[:servers].find {
                          |attrib| attrib['id'] == server_id
                        }
                            server['connectedStorages'] << storage
                        else
                            raise Fog::Errors::NotFound.new(
                              'The requested server resource could not be found'
                            )
                        end
                    else
                        raise Fog::Errors::NotFound.new(
                          'The requested storage resource could not be found'
                        )
                    end

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