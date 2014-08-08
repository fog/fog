module Fog
    module Compute
        class ProfitBricks
            class Real
                require 'fog/profitbricks/parsers/compute/delete_storage'

                # Delete a virtual storage
                #
                # ==== Parameters
                # * storageId<~String> - 
                #
                # ==== Returns
                # * response<~Excon::Response>:
                #   * body<~Hash>:
                #     * deleteStorageResponse<~Hash>:
                #       * requestId<~String> - ID of request
                #       * dataCenterId<~String> - UUID of virtual data center
                #       * dataCenterVersion<~Integer> - Version of the virtual data center
                #
                # {ProfitBricks API Documentation}[http://www.profitbricks.com/apidoc/DeleteStorage.html]
                def delete_storage(storage_id)
                    soap_envelope = Fog::ProfitBricks.construct_envelope {
                      |xml| xml[:ws].deleteStorage {
                        xml.storageId(storage_id)
                      }
                    }

                    request(
                        :expects => [200],
                        :method  => 'POST',
                        :body    => soap_envelope.to_xml,
                        :parser  => 
                          Fog::Parsers::Compute::ProfitBricks::DeleteStorage.new
                    )
                rescue Excon::Errors::InternalServerError => error
                    Fog::Errors::NotFound.new(error)
                end
            end

            class Mock
                def delete_storage(storage_id)
                    response = Excon::Response.new
                    response.status = 200

                    if storage = self.data[:volumes].find {
                      |attrib| attrib['storageId'] == storage_id
                    }
                        self.data[:volumes].delete(storage)
                    else
                        raise Fog::Errors::NotFound.new(
                          'The requested resource could not be found'
                        )
                    end

                    response.body = { 'deleteStorageResponse' => {
                        'requestId'         => Fog::Mock::random_numbers(7),
                        'dataCenterId'      => Fog::UUID.uuid,
                        'dataCenterVersion' => 3
                        }
                    }
                    response
                end
            end
        end
    end
end