module Fog
    module Compute
        class ProfitBricks
            class Real
                require 'fog/profitbricks/parsers/compute/create_nic'

                # Create new virtual network interface
                #
                # ==== Parameters
                # * serverId<~String> - Required, 
                # * lanId - Required,
                # * options<~Hash>:
                #   * nicName<~String> - Optional, name of the new virtual network interface
                #   * ip<~String> - Optional, 
                #   * dhcpActive<~String> - Optional, 
                #
                # ==== Returns
                # * response<~Excon::Response>:
                #   * body<~Hash>:
                #     * createNicResponse<~Hash>:
                #       * requestId<~String> - ID of request
                #       * dataCenterId<~String> - UUID of virtual data center
                #       * dataCenterVersion<~Integer> - Version of the virtual data center
                #       * nicId<~String> - UUID of the new virtual network interface
                #
                # {ProfitBricks API Documentation}[http://www.profitbricks.com/apidoc/CreateNIC.html]
                def create_nic(server_id, lan_id, options={})
                    soap_envelope = Fog::ProfitBricks.construct_envelope {
                      |xml| xml[:ws].createNic {
                        xml.request {
                          xml.serverId(server_id)
                          xml.lanId(lan_id)
                          options.each { |key, value| xml.send(key, value) }
                        }
                      }
                    }

                    request(
                        :expects => [200],
                        :method  => 'POST',
                        :body    => soap_envelope.to_xml,
                        :parser  => 
                          Fog::Parsers::Compute::ProfitBricks::CreateNic.new
                    )
                end
            end

            class Mock
                def create_nic(server_id, lan_id, options={})
                    response = Excon::Response.new
                    response.status = 200
                    
                    nic_id = Fog::UUID.uuid
                    nic = {
                        'nicId'             => nic_id,
                        'lanId'             => lan_id,
                        'nicName'           => options['nicName'] || '',
                        'internetAccess'    => options['internetAccess'] || 'false',
                        'ip'                => options['ip'] || nil,
                        'macAddress'        => Fog::Mock::random_hex(12),
                        'firewall'          => {},
                        'dhcpActive'        => options['dhcpActive'] || 'false',
                        'provisioningState' => 'AVAILABLE'
                    }
                    
                    self.data[:interfaces] << nic
                    response.body = {
                      'createNicResponse' => 
                      {
                        'requestId'         => Fog::Mock::random_numbers(7),
                        'dataCenterId'      => Fog::UUID.uuid,
                        'dataCenterVersion' => 1,
                        'nicId'             => nic_id
                      }
                    }
                    response
                end
            end
        end
    end
end
