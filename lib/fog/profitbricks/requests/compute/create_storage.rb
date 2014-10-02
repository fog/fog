module Fog
    module Compute
        class ProfitBricks
            class Real
                require 'fog/profitbricks/parsers/compute/create_storage'

                # Create new virtual storage
                #
                # ==== Parameters
                # * dataCenterId<~String> - Required, UUID of virtual data center
                # * size<~Integer> - Required, size of virtual storage
                # * options<~Hash>:
                #   * storageName<~String> - Optional, name of the new virtual storage
                #   * mountImageId<~String> - Optional, UUID of image
                #   * profitBricksImagePassword<~String> - Optional, 
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
                # {ProfitBricks API Documentation}[http://www.profitbricks.com/apidoc/CreateStorage.html]
                def create_storage(data_center_id, size, options={})
                    soap_envelope = Fog::ProfitBricks.construct_envelope {
                      |xml| xml[:ws].createStorage {
                        xml.request {
                          xml.dataCenterId(data_center_id)
                          xml.size(size)
                          options.each { |key, value| xml.send(key, value) }
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
                def create_storage(data_center_id, size, options={})
                    response = Excon::Response.new
                    response.status = 200
                    
                    if data_center = self.data[:datacenters].find {
                        |attrib| attrib['dataCenterId'] == data_center_id
                    }
                        data_center['dataCenterVersion'] += 1
                    else
                        raise Fog::Errors::NotFound.new('Data center resource could not be found')
                    end

                    if image = self.data[:images].find {
                        |attrib| attrib['imageId'] == options['mountImageId']
                    }
                        mount_image = {
                            'imageId'   => options['mountImageId'],
                            'imageName' => image['imageName']
                        }
                    end

                    storage_id = Fog::UUID.uuid
                    storage = {
                        'dataCenterId'         => data_center_id,
                        'dataCenterVersion'    => data_center['dataCenterVersion'],
                        'storageId'            => storage_id,
                        'size'                 => size,
                        'storageName'          => options['storageName'] || '',
                        'mountImage'           => mount_image || {},
                        'provisioningState'    => 'AVAILABLE',
                        'creationTime'         => Time.now,
                        'lastModificationTime' => Time.now,
                        'profitBricksImagePassword' => options['profitBricksImagePassword'] || ''
                    }
                    
                    self.data[:volumes] << storage
                    response.body = {
                      'createStorageResponse' => {
                        'requestId'         => Fog::Mock::random_numbers(7),
                        'dataCenterId'      => Fog::UUID.uuid,
                        'dataCenterVersion' => 1,
                        'storageId'         => storage_id
                      }
                    }
                    response
                end
            end
        end
    end
end
