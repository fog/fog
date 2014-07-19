module Fog
    module Compute
        class ProfitBricks
            class Real
                require 'fog/profitbricks/parsers/compute/create_storage'

                # Create a new virtual storage
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
                def create_storage(storage_name, region='DEFAULT')
                    soap_envelope = Fog::ProfitBricks.construct_envelope {
                      |xml| xml[:ws].createStorage {
                        xml.dataCenterName(storage_name)
                        xml.region(region)
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
                def create_storage(storage_name, region='DEFAULT')
                    response = Excon::Response.new
                    response.status = 200
                    
                    storage = {
                        'requestId'         => Fog::Mock::random_numbers(7),
                        'dataCenterId'      => Fog::UUID.uuid,
                        'dataCenterName'    => storage_name,
                        'dataCenterVersion' => 1,
                        'provisioningState' => 'AVAILABLE',
                        'region'            => region
                    }
                    
                    self.data[:datacenters] << storage
                    response.body = { 'createStorageResponse' => storage }
                    response
                end
            end
        end
    end
end