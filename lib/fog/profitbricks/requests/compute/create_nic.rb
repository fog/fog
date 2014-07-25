module Fog
    module Compute
        class ProfitBricks
            class Real
                require 'fog/profitbricks/parsers/compute/create_nic'

                # Create new virtual network interface
                #
                # ==== Parameters
                # * ip<~String> - 
                # * nicName<~String> - Name of the new virtual network interface
                # * dhcpActive<~String> - 
                # * serverId<~Integer> -
                # * lanId -
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
                # {ProfitBricks API Documentation}[http://www.profitbricks.com/apidoc/APIDocumentation.html?createNic.html]
                def create_nic(ip_address, nic_name, dhcp_active,
                               server_id, lan_id)
                    soap_envelope = Fog::ProfitBricks.construct_envelope {
                      |xml| xml[:ws].createNic {
                        xml.request {
                          xml.ip(ip_address)
                          xml.nicName(nic_name)
                          xml.dhcpActive(dhcp_active)
                          xml.serverId(server_id)
                          xml.nicId(nic_id)
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
                def create_nic(ip_address, nic_name, dhcp_active,
                               server_id, lan_id)
                    response = Excon::Response.new
                    response.status = 200
                    

                    nic_id = Fog::UUID.uuid
                    nic = {
                        #'dataCenterId'      => data_center_id,
                        #'dataCenterVersion' => data_center['dataCenterVersion'],
                        'id'                => nic_id,
                        'lan_id'            => lan_id,
                        'internetAccess'    => '',
                        'serverId'          => server_id,
                        'ips'               => ip_address,
                        'macAddress'        => nil,
                        'firewall' =>
                        {
                            'active'            => 'false',
                            'firewallId'        => nil,
                            'nicId'             => nic_id,
                            'provisioningState' => 'AVAILABLE',
                        },
                        'dhcpActive'        => dhcp_active,
                        'provisioningState' => 'AVAILABLE'
                    }
                    
                    self.data[:interfaces] << nic
                    response.body = {
                      'createStorageResponse' => 
                      {
                        'requestId'         => Fog::Mock::random_numbers(7),
                        'dataCenterId'      => data_center_id,
                        'dataCenterVersion' => data_center['dataCenterVersion'],
                        'id'                => nic_id
                      }
                    }
                    response
                end
            end
        end
    end
end