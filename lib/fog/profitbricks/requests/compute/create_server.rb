module Fog
    module Compute
        class ProfitBricks
            class Real
                require 'fog/profitbricks/parsers/compute/create_server'

                # Create new virtual server
                #
                # ==== Parameters
                # * dataCenterId<~String> - 
                # * cores<~Integer> - 
                # * ram<~Integer> -
                # * serverName<~String> - Name of the new virtual network interface
                # * bootFromStorageId<~String> - 
                # * bootFromImageId<~<String> - 
                # * internetAccess<~String> - 
                # * lanId<~String> - 
                # * osType<~String> -
                # * availabilityZone - AUTO, ZONE_1, ZONE_2
                #
                # ==== Returns
                # * response<~Excon::Response>:
                #   * body<~Hash>:
                #     * createServerResponse<~Hash>:
                #       * requestId<~String> - ID of request
                #       * dataCenterId<~String> - UUID of virtual data center
                #       * dataCenterVersion<~Integer> - Version of the virtual data center
                #       * serverId<~String> - UUID of the new virtual server
                #
                # {ProfitBricks API Documentation}[http://www.profitbricks.com/apidoc/APIDocumentation.html?createServer.html]
                def create_server(data_center_id, cores, ram, server_name,
                                  #boot_from_storage_id, boot_from_image_id,
                                  internet_access, lan_id, os_type,
                                  availability_zone = 'AUTO')
                    soap_envelope = Fog::ProfitBricks.construct_envelope {
                      |xml| xml[:ws].createServer {
                        xml.request {
                          xml.dataCenterId(data_center_id)
                          xml.cores(cores)
                          xml.ram(ram)
                          xml.serverName(server_name)
                          #xml.bootFromStorageId(boot_from_storage_id)
                          #xml.bootFromImageId(boot_from_image_id)
                          xml.internetAccess(server_name)
                          xml.lanId(lan_id)
                          xml.osType(os_type)
                          xml.availabilityZone(availability_zone)
                        }
                      }
                    }

                    request(
                        :expects => [200],
                        :method  => 'POST',
                        :body    => soap_envelope.to_xml,
                        :parser  => 
                          Fog::Parsers::Compute::ProfitBricks::CreateServer.new
                    )
                end
            end

            class Mock
                def create_server(data_center_id, cores, ram, server_name,
                                  boot_from_storage_id, boot_from_image_id,
                                  internet_access, lan_id, os_type,
                                  availability_zone)
                    response = Excon::Response.new
                    response.status = 200
                    

                    server_id = Fog::UUID.uuid
                    server = {
                        'id'                   => server_id,
                        'cores'                => cores,
                        'ram'                  => ram,
                        'serverName'           => server_name,
                        'internetAccess'       => internet_access,
                        'ips'                  => [],
                        'connectedStorages'    => [],
                        'romDrives'            => [],
                        'nics'                 => [],
                        'provisioningState'    => 'AVAILABLE',
                        'virtualMachineState'  => 'RUNNING',
                        'creationTime'         => Time.now,
                        'lastModificationTime' => Time.now,
                        'osType'               => 'LINUX',
                        'availabilityZone'     => 'AUTO',
                        #'cpuHotPlug'           => 'true',
                        #'ramHotPlug'           => 'true',
                        #'nicHotPlug'           => 'true',
                        #'nicHotUnPlug'         => 'true',
                        #'discVirtioHotPlug'    => 'true',
                        #'discVirtioHotUnPlug'  => 'true'
                    }
                    
                    self.data[:servers] << server
                    response.body = {
                      'createServerResponse' => {
                        'requestId'         => Fog::Mock::random_numbers(7),
                        'dataCenterId'      => Fog::UUID.uuid,
                        'dataCenterVersion' => 1,
                        'id'                => server_id
                      }
                    }
                    response
                end
            end
        end
    end
end