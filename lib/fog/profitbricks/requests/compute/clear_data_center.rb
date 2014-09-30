module Fog
    module Compute
        class ProfitBricks
            class Real
                require 'fog/profitbricks/parsers/compute/clear_data_center'

                # Clear all objects within a virtual data center
                #
                # ==== Parameters
                # * dataCenterId<~String> - Required, UUID of virtual data center
                #
                # ==== Returns
                # * response<~Excon::Response>:
                #   * body<~Hash>:
                #     * clearDataCenterResponse<~Hash>:
                #       * requestId<~String> - ID of request
                #       * dataCenterId<~String> - UUID of virtual data center
                #       * dataCenterVersion<~Integer> - Version of the virtual data center
                #
                # {ProfitBricks API Documentation}[http://www.profitbricks.com/apidoc/ClearDataCenter.html]
                def clear_data_center(data_center_id)
                    soap_envelope = Fog::ProfitBricks.construct_envelope {
                      |xml| xml[:ws].clearDataCenter {
                        xml.dataCenterId(data_center_id)
                      }
                    }

                    request(
                        :expects => [200],
                        :method  => 'POST',
                        :body    => soap_envelope.to_xml,
                        :parser  =>
                          Fog::Parsers::Compute::ProfitBricks::ClearDataCenter.new
                    )
                end
            end

            class Mock
                def clear_data_center(data_center_id)
                    response        = Excon::Response.new
                    response.status = 200
                    response.body = { 'clearDataCenterResponse' =>
                      { 'requestId'         => Fog::Mock::random_numbers(7),
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