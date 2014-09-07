module Fog
    module Compute
        class ProfitBricks
            class Real
                require 'fog/profitbricks/parsers/compute/create_server'

                # Create new virtual server
                #
                # ==== Parameters
                # * dataCenterId<~String> - Required, UUID of virtual data center
                # * cores<~Integer> - Required, number of CPU cores allocated to virtual server
                # * ram<~Integer> - Required, amount of memory in GB allocated to virtual server
                # * options<~Hash>:
                #   * serverName<~String> - Name of the new virtual network interface
                #   * bootFromStorageId<~String> - Optional, 
                #   * bootFromImageId<~<String> - Optional, 
                #   * internetAccess<~Boolean> - Optional, 
                #   * lanId<~String> - Optional, 
                #   * osType<~String> - Optional, UNKNOWN, WINDOWS, LINUX, OTHER
                #   * availabilityZone - Optional, AUTO, ZONE_1, ZONE_2
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
                # {ProfitBricks API Documentation}[http://www.profitbricks.com/apidoc/CreateServer.html]
                def create_server(data_center_id, cores, ram, options={})
                    soap_envelope = Fog::ProfitBricks.construct_envelope {
                      |xml| xml[:ws].createServer {
                        xml.request {
                          xml.dataCenterId(data_center_id)
                          xml.cores(cores)
                          xml.ram(ram)
                          options.each { |key, value| xml.send(key, value) }
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
                def create_server(data_center_id, cores, ram, options={})
                    server_id = Fog::UUID.uuid

                    server = {
                        'serverId'             => server_id,
                        'cores'                => cores,
                        'ram'                  => ram,
                        'serverName'           => options['serverName'],
                        'internetAccess'       => options['internetAccess'] || 'false',
                        #'ips'                  => options['ips'] || '',
                        'connectedStorages'    => options['connectedStorages'] || [],
                        'romDrives'            => options['romDrives'] || [],
                        'nics'                 => options['nics'] || [],
                        'provisioningState'    => 'AVAILABLE',
                        'virtualMachineState'  => 'RUNNING',
                        'creationTime'         => Time.now,
                        'lastModificationTime' => Time.now,
                        'osType'               => options['osType'] || 'UNKNOWN',
                        'availabilityZone'     => options['availabilityZone'] || 'AUTO',
                        'dataCenterId'         => Fog::UUID.uuid,
                        'dataCenterVersion'    => 1
                        ##'cpuHotPlug'           => 'true',
                        ##'ramHotPlug'           => 'true',
                        ##'nicHotPlug'           => 'true',
                        ##'nicHotUnPlug'         => 'true',
                        ##'discVirtioHotPlug'    => 'true',
                        ##'discVirtioHotUnPlug'  => 'true'
                    }
                    
                    self.data[:servers] << server

                    response = Excon::Response.new
                    response.status = 200
                    response.body = {
                      'createServerResponse' => {
                        'requestId'         => Fog::Mock::random_numbers(7),
                        'dataCenterId'      => Fog::UUID.uuid,
                        'dataCenterVersion' => 1,
                        'serverId'          => server_id
                      }
                    }
                    response
                end
            end
        end
    end
end
