module Fog
    module Compute
        class ProfitBricks
            class Real
                require 'fog/profitbricks/parsers/compute/get_storage'
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
                    response        = Excon::Response.new
                    response.status = 200

                    if storage = self.data[:volumes].find {
                      |attrib| attrib['id'] == storage_id
                    }
                    else
                        raise Fog::Errors::NotFound.new('The requested resource could not be found')
                    end

                    response.body = { 'getStorageResponse' => storage }
                    response
                end
            end
        end
    end
end
