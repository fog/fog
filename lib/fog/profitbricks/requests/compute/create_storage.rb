module Fog
    module Compute
        class ProfitBricks
            class Real
                require 'fog/profitbricks/parsers/compute/create_storage'

                # Create new virtual storage
                #
                # ==== Parameters
                # * dataCenterId<~String> - 
                # * storageName<~String> - Name of the new virtual storage
                # * mountImageId<~String> - 
                # * size<~Integer> -
                #
                # ==== Returns
                # * response<~Excon::Response>:
                #   * body<~Hash>:
                #     * createStorageResponse<~Hash>:
                #       * requestId<~String> - ID of request
                #       * dataCenterId<~String> - UUID of virtual data center
                #       * dataCenterVersion<~Integer> - Version of the virtual data center
                #       * storageId<~String> - UUID of the new virtual storage
                #
                # {ProfitBricks API Documentation}[http://www.profitbricks.com/apidoc/APIDocumentation.html?createStorage.html]
                def create_storage(data_center_id, storage_name,
                                   mount_image_id, size)
                    soap_envelope = Fog::ProfitBricks.construct_envelope {
                      |xml| xml[:ws].createStorage {
                        xml.dataCenterId(data_center_id),
                        xml.storageName(storage_name),
                        xml.mountImageId(mount_image_id),
                        xml.size(size)
                      }
                    }

                    request(
                        :expects => [200],
                        :method  => 'POST',
                        :body    => soap_envelope.to_xml,
                        :parser  => 
                          Fog::Parsers::Compute::ProfitBricks::CreateStorage.new
                    )
                end
            end

            class Mock
                def create_storage(data_center_id, storage_name,
                                   mount_image_id, size)
                    response = Excon::Response.new
                    response.status = 200
                    
                    storage = {
                        'requestId'         => Fog::Mock::random_numbers(7),
                        'dataCenterId'      => data_center_id,
                        'dataCenterVersion' => 1,
                        'storageId'         => Fog::UUID.uuid
                    }
                    
                    self.data[:storages] << storage
                    response.body = { 'createStorageResponse' => storage }
                    response
                end
            end
        end
    end
end