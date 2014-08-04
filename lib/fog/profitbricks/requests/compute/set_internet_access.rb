module Fog
    module Compute
        class ProfitBricks
            class Real
                require 'fog/profitbricks/parsers/compute/set_internet_access'

                # Connect an existing NIC to a public LAN to get internet access
                #
                # ==== Parameters
                # * dataCenterId<~String> -
                # * lanId<~Integer> -
                # * internetAccess<~Boolean> - 
                #
                # ==== Returns
                # * response<~Excon::Response>:
                #   * body<~Hash>:
                #     * setInternetAccessResponse<~Hash>:
                #       * requestId<~String> - ID of request
                #       * dataCenterId<~String> - UUID of virtual data center
                #       * dataCenterVersion<~Integer> - Version of the virtual data center
                #
                # {ProfitBricks API Documentation}[http://www.profitbricks.com/apidoc/SetInternetAccess.html]
                def set_internet_access(data_center_id, lan_id, internet_access)
                    soap_envelope = Fog::ProfitBricks.construct_envelope {
                      |xml| xml[:ws].setInternetAccess {
                        xml.dataCenterId(data_center_id)
                        xml.lanId(lan_id)
                        xml.internetAccess(internet_access)
                      }
                    }

                    request(
                        :expects => [200],
                        :method  => 'POST',
                        :body    => soap_envelope.to_xml,
                        :parser  =>
                          Fog::Parsers::Compute::ProfitBricks::SetInternetAccess.new
                    )
                rescue Excon::Errors::InternalServerError => error
                    Fog::Errors::NotFound.new(error)
                end
            end

            class Mock
                def set_internet_access(data_center_id, lan_id, internet_access)
                    response        = Excon::Response.new
                    response.status = 200
                    response.body   = {
                      'setInternetAccessResponse' =>
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