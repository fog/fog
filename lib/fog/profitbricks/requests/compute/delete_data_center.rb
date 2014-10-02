module Fog
    module Compute
        class ProfitBricks
            class Real
                require 'fog/profitbricks/parsers/compute/delete_data_center'

                # Delete virtual data center
                #
                # ==== Parameters
                # * dataCenterId<~String> - UUID of the virtual data center
                #
                # ==== Returns
                # * response<~Excon::Response>:
                #   * body<~Hash>:
                #     * deleteDataCenterResponse<~Hash>:
                #       * requestId<~String> - ID of request
                #       * dataCenterId<~String> - UUID of virtual data center
                #       * dataCenterVersion<~Integer> - Version of the virtual data center
                #
                # {ProfitBricks API Documentation}[http://www.profitbricks.com/apidoc/DeleteDataCenter.html]
                def delete_data_center(data_center_id)
                    soap_envelope = Fog::ProfitBricks.construct_envelope {
                      |xml| xml[:ws].deleteDataCenter {
                        xml.dataCenterId(data_center_id)
                      }
                    }

                    request(
                        :expects => [200],
                        :method  => 'POST',
                        :body    => soap_envelope.to_xml,
                        :parser  => 
                          Fog::Parsers::Compute::ProfitBricks::DeleteDataCenter.new
                    )
                rescue Excon::Errors::InternalServerError => error
                    Fog::Errors::NotFound.new(error)
                end
            end

            class Mock
                def delete_data_center(data_center_id)
                    response = Excon::Response.new
                    response.status = 200
                    
                    if data_center = self.data[:datacenters].find {
                      |attrib| attrib['dataCenterId'] == data_center_id
                    }
                        self.data[:datacenters].delete(data_center)
                    else
                        raise Fog::Errors::NotFound.new('The requested resource could not be found')
                    end

                    response.body = { 'deleteDataCenterResponse' => {
                        'requestId' => data_center['requestId']
                        }
                    }
                    response
                end
            end
        end
    end
end
