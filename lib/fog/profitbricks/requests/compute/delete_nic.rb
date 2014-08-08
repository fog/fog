module Fog
    module Compute
        class ProfitBricks
            class Real
                require 'fog/profitbricks/parsers/compute/delete_nic'

                # Delete virtual network interface
                #
                # ==== Parameters
                # * nicId<~String> - UUID of the virtual network interface
                #
                # ==== Returns
                # * response<~Excon::Response>:
                #   * body<~Hash>:
                #     * deleteNicResponse<~Hash>:
                #       * requestId<~String> - ID of request
                #       * dataCenterId<~String> - UUID of virtual data center
                #       * dataCenterVersion<~Integer> - Version of the virtual data center
                #
                # {ProfitBricks API Documentation}[http://www.profitbricks.com/apidoc/DeleteNic.html]
                def delete_nic(nic_id)
                    soap_envelope = Fog::ProfitBricks.construct_envelope {
                      |xml| xml[:ws].deleteNic {
                        xml.nicId(nic_id)
                      }
                    }

                    request(
                        :expects => [200],
                        :method  => 'POST',
                        :body    => soap_envelope.to_xml,
                        :parser  => 
                          Fog::Parsers::Compute::ProfitBricks::DeleteNic.new
                    )
                rescue Excon::Errors::InternalServerError => error
                    Fog::Errors::NotFound.new(error)
                end
            end

            class Mock
                def delete_nic(nic_id)
                    response = Excon::Response.new
                    response.status = 200
                    
                    if nic = self.data[:interfaces].find {
                      |attrib| attrib['nicId'] == nic_id
                    }
                        self.data[:interfaces].delete(nic)
                    else
                        raise Fog::Errors::NotFound.new(
                          'The requested NIC could not be found'
                        )
                    end

                    response.body = { 'deleteNicResponse' => {
                        'requestId'         => Fog::Mock::random_numbers(7),
                        'dataCenterId'      => Fog::UUID.uuid,
                        'dataCenterVersion' => 1,
                        }
                    }
                    response
                end
            end
        end
    end
end