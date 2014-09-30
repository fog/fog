module Fog
    module Compute
        class ProfitBricks
            class Real
                require 'fog/profitbricks/parsers/compute/get_storage'

                # Returns all virtual storage information
                #
                # ==== Parameters
                # * N/A
                #
                # ==== Returns
                # * response<~Excon::Response>:
                #   * body<~Hash>:
                #     * getStorage<~Hash>:
                #       * dataCenterId<~String> - UUID of the virtual data center
                #       * dataCenterVersion<~Integer> - Version of the virtual data center
                #       * storageId<~String> - UUID of the virtual storage
                #       * size<~Integer> - Size of the virtual storage in GB
                #       * storageName<~String> - Name of the virtual storage
                #       * mountImage<~Hash>:
                #         * imageId<~String> - 
                #         * imageName<~String> - 
                #       * serverIds<~String> - List of servers connected to the virtual storage by UUID
                #       * provisioningState<~String> - Current provisioning state of virtual storage 
                #       * creationTime<~Time> - Time when virtual storage was created
                #       * lastModificationTime<~Time> - Time when the virtual storage was last modified
                #
                # {ProfitBricks API Documentation}[http://www.profitbricks.com/apidoc/GetStorage.html]
                def get_storage(storage_id)
                    soap_envelope = Fog::ProfitBricks.construct_envelope {
                      |xml| xml[:ws].getStorage {
                        xml.storageId(storage_id)
                      }
                    }

                    request(
                        :expects => [200],
                        :method  => 'POST',
                        :body    => soap_envelope.to_xml,
                        :parser  =>
                          Fog::Parsers::Compute::ProfitBricks::GetStorage.new
                    )
                rescue Excon::Errors::InternalServerError => error
                    Fog::Errors::NotFound.new(error)
                end
            end

            class Mock
                def get_storage(storage_id)
                    if storage = self.data[:volumes].find {
                      |attrib| attrib['storageId'] == storage_id
                    }
                    else
                        raise Fog::Errors::NotFound.new('The requested resource could not be found')
                    end

                    response        = Excon::Response.new
                    response.status = 200
                    response.body   = { 'getStorageResponse' => storage }
                    response
                end
            end
        end
    end
end
