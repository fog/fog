module Fog
    module Compute
        class ProfitBricks
            class Real
                require 'fog/profitbricks/parsers/compute/create_data_center'

                # Create a new virtual data center
                #
                # ==== Parameters
                #   dataCenterName<~String> - Name of the new virtual data center
                #   location<~String> - Location to create the new data center ("de/fkb", "de/fra", or "us/las")
                #
                # ==== Returns
                # * response<~Excon::Response>:
                #   * body<~Hash>:
                #     * createDataCenterResponse<~Hash>:
                #       * requestId<~String> - ID of request
                #       * dataCenterId<~String> - UUID of virtual data center
                #       * dataCenterVersion<~Integer> - Version of the virtual data center
                #       * location<~String> - Location of virtual data center
                #
                # {ProfitBricks API Documentation}[http://www.profitbricks.com/apidoc/CreateDataCenter.html]
                def create_data_center(data_center_name='', location='')
                    soap_envelope = Fog::ProfitBricks.construct_envelope {
                        |xml| xml[:ws].createDataCenter {
                        xml.request {
                            xml.dataCenterName(data_center_name)
                            xml.location(location)
                        }
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
                def create_data_center(data_center_name='', location='')

                    data_center = {
                        'requestId'         => Fog::Mock::random_numbers(7),
                        'dataCenterId'      => Fog::UUID.uuid,
                        'dataCenterName'    => data_center_name || '',
                        'location'          => location || '',
                        'dataCenterVersion' => 1,
                        'provisioningState' => 'AVAILABLE'
                    }

                    self.data[:datacenters] << data_center
                    response        = Excon::Response.new
                    response.status = 200
                    response.body   = { 'createDataCenterResponse' => data_center }
                    response
                end
            end
        end
    end
end
