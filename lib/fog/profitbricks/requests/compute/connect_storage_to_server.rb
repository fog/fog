module Fog
    module Compute
        class ProfitBricks
            class Real
                require 'fog/profitbricks/parsers/compute/connect_storage_to_server'

                # Connect a virtual storage
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
                def connect_storage_to_server(bus_type, device_number,
                                              storage_id, server_id)
                    soap_envelope = Fog::ProfitBricks.construct_envelope {
                      |xml| xml[:ws].connectStorageToServer {
                        xml.request { 
                          xml.busType(bus_type)
                          xml.deviceNumber(device_number)
                          xml.storageId(storage_id)
                          xml.serverId(serverId)
                        }
                      }
                    }

                    request(
                        :expects => [200],
                        :method  => 'POST',
                        :body    => soap_envelope.to_xml,
                        :parser  => 
                          Fog::Parsers::Compute::ProfitBricks::UpdateStorage.new
                    )
                rescue Excon::Errors::InternalServerError => error
                    Fog::Errors::NotFound.new(error)
                end
            end

            class Mock
                def connect_storage_to_server(bus_type, device_number,
                                              storage_id, server_id)
                    response = Excon::Response.new
                    response.status = 200
                    
                    if storage = self.data[:storages].find {
                      |attrib| attrib['storageId'] == storage_id
                    }
                        storage['size'] = size
                    else
                        raise Fog::Errors::NotFound.new('The requested resource could not be found')
                    end
                    
                    response.body = { 'connectStorageToServerResponse' => storage }
                    response
                end
            end
        end
    end
end