module Fog
    module Compute
        class ProfitBricks
            class Real
                require 'fog/profitbricks/parsers/compute/create_data_center'
                # Create a new virtual data center
                # {ProfitBricks API Documentation}[http://www.profitbricks.com/apidoc/APIDocumentation.html?CreateDataCenter.html]
                #
                # ==== Parameters
                # * dataCenterName<~String> - Name of the new virtual data center
                # * region<~String> - Region to create the new data center (NORTH_AMERICA, EUROPE, or DEFAULT)
                #
                # ==== Returns
                # * response<~Excon::Response>:
                #   * body<~Hash>:
                #     * createDataCenterResponse<~Hash>:
                #       * requestId<~String> - ID of request
                #       * dataCenterId<~String> - UUID of virtual data center
                #       * dataCenterVersion<~Integer> - Version of the virtual data center
                #       * region<~String> - Region of virtual data center
                #
                def create_data_center(data_center_name, region='DEFAULT')
                    soap_envelope = Fog::ProfitBricks.construct_envelope {
                      |xml| xml[:ws].createDataCenter {
                        xml.dataCenterName(data_center_name)
                        xml.region(region)
                      }
                    }

                    request(
                        :expects => [200],
                        :method  => 'POST',
                        :body    => soap_envelope.to_xml,
                        :parser  => 
                          Fog::Parsers::Compute::ProfitBricks::CreateDataCenter.new
                    )
                end
            end

            class Mock
                def create_data_center(data_center_name, region='DEFAULT')
                    response = Excon::Response.new
                    response.status = 200
                    
                    data_center = {
                        'requestId'         => Fog::Mock::random_numbers(7),
                        'dataCenterId'      => Fog::UUID.uuid,
                        'dataCenterName'    => data_center_name,
                        'dataCenterVersion' => 1,
                        'provisioningState' => 'AVAILABLE',
                        'region'            => region
                    }
                    
                    self.data[:datacenters] << data_center
                    response.body = { 'createDataCenterResponse' => data_center }
                    response
                end
            end
        end
    end
end
