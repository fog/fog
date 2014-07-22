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
                def create_storage(data_center_id, storage_name, image_id, size)
                    soap_envelope = Fog::ProfitBricks.construct_envelope {
                      |xml| xml[:ws].createStorage {
                        xml.request {
                          xml.dataCenterId(data_center_id)
                          xml.storageName(storage_name)
                          xml.mountImageId(image_id)
                          xml.size(size)
                        }
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
                def create_storage(data_center_id, storage_name, image_id, size)
                    response = Excon::Response.new
                    response.status = 200
                    
                    if data_center = self.data[:datacenters].find {
                        |attrib| attrib['id'] == data_center_id
                    }
                        data_center['dataCenterVersion'] += 1
                    else
                        raise Fog::Errors::NotFound.new('Data center resource could not be found')
                    end

                    unless image = self.data[:images].find {
                        |attrib| attrib['id'] == image_id
                    }
                        raise Fog::Errors::NotFound.new('Image resource could not be found')
                    end

                    storage_id = Fog::UUID.uuid
                    storage = {
                        'dataCenterId'         => data_center_id,
                        'dataCenterVersion'    => data_center['dataCenterVersion'],
                        'id'                   => storage_id,
                        'size'                 => size,
                        'name'                 => storage_name,
                        'mountImage'           =>
                        {
                            'imageId'   => image_id,
                            'imageName' => image['name'],
                        },
                        'provisioningState'    => 'AVAILABLE',
                        'creationTime'         => Time.now,
                        'lastModificationTime' => Time.now
                    }
                    
                    self.data[:volumes] << storage
                    response.body = {
                      'createStorageResponse' => {
                        'requestId'         => Fog::Mock::random_numbers(7),
                        'dataCenterId'      => data_center_id,
                        'dataCenterVersion' => data_center['dataCenterVersion'],
                        'id'                => storage_id
                      }
                    }
                    response
                end
            end
        end
    end
end