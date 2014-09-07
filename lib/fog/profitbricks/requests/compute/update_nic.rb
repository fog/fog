module Fog
    module Compute
        class ProfitBricks
            class Real
                require 'fog/profitbricks/parsers/compute/update_nic'

                # Update a virtual NIC
                #
                # ==== Parameters
                # * nicId<~String> - Required, 
                # * options<~Hash>:
                #   * lanId<~Integer> - Optional, 
                #   * nicName<~String> - Optional, name of the new virtual network interface
                #   * ip<~String> - Optional, 
                #   * dhcpActive<~Boolean> - Optional, 
                #
                # ==== Returns
                # * response<~Excon::Response>:
                #   * body<~Hash>:
                #     * updateNicResponse<~Hash>:
                #       * requestId<~String> - ID of request
                #       * dataCenterId<~String> - UUID of virtual data center
                #       * dataCenterVersion<~Integer> - Version of the virtual data center
                #
                # {ProfitBricks API Documentation}[http://www.profitbricks.com/apidoc/UpdateNIC.html]
                def update_nic(nic_id, options={})
                    soap_envelope = Fog::ProfitBricks.construct_envelope {
                      |xml| xml[:ws].updateNic {
                        xml.request { 
                          xml.nicId(nic_id)
                          options.each { |key, value| xml.send(key, value) }
                        }
                      }
                    }

                    request(
                        :expects => [200],
                        :method  => 'POST',
                        :body    => soap_envelope.to_xml,
                        :parser  =>
                          Fog::Parsers::Compute::ProfitBricks::UpdateNic.new
                    )
                rescue Excon::Errors::InternalServerError => error
                    Fog::Errors::NotFound.new(error)
                end
            end

            class Mock
                def update_nic(nic_id, options={})

                    if nic = self.data[:interfaces].find {
                      |attrib| attrib['nicId'] == nic_id
                    }
                        options.each do |key, value|
                            nic[key] = value
                        end
                    else
                        raise Fog::Errors::NotFound.new('The requested NIC could not be found')
                    end
                    
                    response        = Excon::Response.new
                    response.status = 200
                    response.body   = {
                      'updateNicResponse' =>
                      {
                        'requestId'         => Fog::Mock::random_numbers(7),
                        'dataCenterId'      => Fog::UUID.uuid,
                        'dataCenterVersion' => 1
                      }
                    }
                    response
                end
            end
        end
    end
end
