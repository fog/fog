require 'fog/profitbricks/core'

module Fog
    module Compute
        class ProfitBricks < Fog::Service
            API_VERSION = '1.3'

            requires    :profitbricks_username, :profitbricks_password
            recognizes  :profitbricks_url

            # Models
            model_path   'fog/profitbricks/models/compute'
            model        :server
            collection   :servers
            model        :datacenter
            collection   :datacenters
            model        :region
            collection   :regions
            model        :image
            collection   :images
            model        :flavor
            collection   :flavors
            model        :volume
            collection   :volumes
            model        :interface
            collection   :interfaces

            # Requests
            request_path 'fog/profitbricks/requests/compute'
            request      :create_server         # createServer
            request      :delete_server         # deleteServer
            request      :update_server         # updateServer
            request      :get_all_servers       # getAllServers
            request      :get_server            # getServer
            request      :reset_server          # resetServer
            request      :start_server          # startServer
            request      :stop_server           # stopServer

            request      :clear_data_center     # clearDataCenter
            request      :create_data_center    # createDataCenter
            request      :delete_data_center    # deleteDataCenter
            request      :update_data_center    # updateDataCenter
            request      :get_all_data_centers  # getAllDataCenters
            request      :get_data_center       # getDataCenter
            request      :get_data_center_state # getDataCenterState

            request      :get_all_locations     # getAllLocations
            request      :get_location          # getLocation

            request      :get_all_images        # getAllImages
            request      :get_image             # getImage

            request      :get_all_flavors       # getAllFlavors
            request      :get_flavor            # getFlavor
            request      :create_flavor         # createFlavor

            request      :create_storage        # createStorage
            request      :delete_storage        # deleteStorage
            request      :update_storage        # updateStorage
            request      :get_all_storages      # getAllStorages
            request      :get_storage           # getStorage
            request      :connect_storage_to_server      # connectStorageToServer
            request      :disconnect_storage_from_server # disconnectStorageFromServer

            request      :create_nic            # createNic
            request      :delete_nic            # deleteNic
            request      :update_nic            # updateNic
            request      :get_all_nic           # getAllNic
            request      :get_nic               # getNic
            request      :set_internet_access   # setInternetAccess

            class Real
                def initialize(options={})
                    @profitbricks_username = options[:profitbricks_username]
                    @profitbricks_password = options[:profitbricks_password]
                    @profitbricks_url      = options[:profitbricks_url] ||
                                             "https://api.profitbricks.com/#{API_VERSION}"

                    @connection = Fog::XML::Connection.new(@profitbricks_url, false)
                end

                def request(params)
                    begin
                        response = @connection.request(params.merge({
                            :headers => {
                                'Authorization' => "Basic #{auth_header}"
                            }.merge!(params[:headers] || {})
                        }))
                    rescue Excon::Errors::Unauthorized => error
                        raise error
                    rescue Excon::Errors::HTTPStatusError => error
                        raise error
                    rescue Excon::Errors::InternalServerError => error
                        raise error
                    end
                    response
                end

                private

                def auth_header
                    return Base64.encode64(
                      "#{@profitbricks_username}:#{@profitbricks_password}"
                    ).delete("\r\n")
                end
            end

            class Mock
                def self.data
                    @data ||= Hash.new do |hash, key|
                        hash[key] = {
                            :servers         => [],
                            :datacenters     => [],
                            :regions         =>
                            [
                                {
                                    'locationId'   => 'c0420cc0-90e8-4f4b-8860-df0a07d18047',
                                    'locationName' => 'de/fkb',
                                    'country'      => 'DEU'
                                },
                                {
                                    'locationId'   => '68c4099a-d9d8-4683-bdc2-12789aacfa2a',
                                    'locationName' => 'de/fra',
                                    'country'      => 'DEU'
                                },
                                {
                                    'locationId'   => 'e102ba74-6764-47f3-8896-246141da8ada',
                                    'locationName' => 'us/las',
                                    'country'      => 'USA'
                                }
                            ],
                            :images =>
                            [
                                {
                                    'imageId'             => 'ece948c0-14f8-4d49-8bdc-b966b746b6f9',
                                    'imageName'           => 'CentOS-6.5-x86_64-netinstall.iso',
                                    'imageType'           => 'CDROM',
                                    'imageSize'           => 244,
                                    'bootable'            => 'true',
                                    'cpuHotPlug'          => 'false',
                                    'cpuHotUnPlug'        => 'false',
                                    'ramHotPlug'          => 'false',
                                    'ramHotUnPlug'        => 'false',
                                    'discVirtioHotPlug'   => 'false',
                                    'discVirtioHotUnPlug' => 'false',
                                    'nicHotPlug'          => 'false',
                                    'nicHotUnPlug'        => 'false',
                                    'osType'              => 'LINUX',
                                    'serverIds'           => nil,
                                    'writeable'           => 'true',
                                    'location'            => 'us/las',
                                    'public'              => 'true'
                                },
                                {
                                    'imageId'             => 'cc43d811-c423-402c-8bd0-6a04073a65ca',
                                    'imageName'           => 'CentOS-6-server',
                                    'imageType'           => 'HDD',
                                    'imageSize'           => 11264,
                                    'bootable'            => 'true',
                                    'cpuHotPlug'          => 'false',
                                    'cpuHotUnPlug'        => 'false',
                                    'ramHotPlug'          => 'false',
                                    'ramHotUnPlug'        => 'false',
                                    'discVirtioHotPlug'   => 'false',
                                    'discVirtioHotUnPlug' => 'false',
                                    'nicHotPlug'          => 'false',
                                    'nicHotUnPlug'        => 'false',
                                    'osType'              => 'LINUX',
                                    'serverIds'           => nil,
                                    'writeable'           => 'true',
                                    'location'            => 'us/las',
                                    'public'              => 'true'
                                }
                            ],
                            :flavors =>
                            [
                                {
                                     'flavorId'   => Fog::UUID.uuid,
                                     'flavorName' => 'Micro',
                                     'ram'        => 1024,
                                     'disk'       => 50,
                                     'cores'      => 1
                                },
                                {
                                     'flavorId'   => Fog::UUID.uuid,
                                     'flavorName' => 'Small',
                                     'ram'        => 2048,
                                     'disk'       => 50,
                                     'cores'      => 1
                                }
                            ],
                            :volumes    => [],
                            :interfaces => []
                        }
                    end
                end

                def self.reset
                    @data = nil
                end

                def initialize(options={})
                    @profitbricks_username = options[:profitbricks_username]
                    @profitbricks_password = options[:profitbricks_password]
                end

                def data
                    self.class.data[@profitbricks_username]
                end

                def reset_data
                    self.class.data.delete(@profitbricks_username)
                end
            end
        end
    end
end
