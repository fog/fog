require 'fog/profitbricks/core'

module Fog
    module Compute
        class ProfitBricks < Fog::Service

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

            # Requests
            request_path 'fog/profitbricks/requests/compute'
            request      :create_server         # createServer
            request      :delete_server         # deleteServer
            request      :get_all_servers       # getAllServers
            request      :get_server            # getServer
            request      :reset_server          # resetServer
            request      :start_server          # startServer
            request      :stop_server           # stopServer
            request      :update_server         # updateServer

            request      :clear_data_center     # clearDataCenter
            request      :create_data_center    # createDataCenter
            request      :delete_data_center    # deleteDataCenter
            request      :get_all_data_centers  # getAllDataCenters
            request      :get_data_center       # getDataCenter
            request      :get_data_center_state # getDataCenterState
            request      :update_data_center    # updateDataCenter

            request      :get_all_regions       # getAllRegions
            request      :get_region            # getRegion

            request      :get_all_images        # getAllImages
            request      :get_image             # getImage

            request      :get_all_flavors       # getAllFlavors
            request      :get_flavor            # getFlavor
            request      :create_flavor         # createFlavor

            class Real
                def initialize(options={})
                    @profitbricks_username = options[:profitbricks_username]
                    @profitbricks_password = options[:profitbricks_password]
                    @profitbricks_url      = options[:profitbricks_url] ||
                                             'https://api.profitbricks.com/1.2'

                    #@connection = Fog::XML::Connection.new('https://api.profitbricks.com/1.2', false)
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
                        #Fog::ProfitBricks.parse_error(error.response.body)
                        raise error
                    rescue Excon::Errors::HTTPStatusError => error
                        #Fog::ProfitBricks.parse_error(error.response.body)
                        raise error
                    rescue Excon::Errors::InternalServerError => error
                        #Fog::ProfitBricks.parse_error(error.response.body)
                        raise error
                    end
                    response
                end

                private

                def parse(response)
                    unless response.body.empty?
                        document = Fog::ToHashDocument.new
                        parser = Nokogiri::XML::SAX::PushParser.new(document)
                        parser << response.body
                        parser.finish
                        response.body = document.body
                    end
                end

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
                            :regions         => [
                              {
                                'id'   => Fog::UUID.uuid,
                                'name' => 'EUROPE'
                              },
                              {
                                'id'   => Fog::UUID.uuid,
                                'name' => 'NORTH_AMERICA'
                              }
                            ],
                            :images          => [
                              { 'id'             => Fog::UUID.uuid,
                                'name'           => 'CentOS-6.5-x86_64-netinstall.iso',
                                'type'           => 'CDROM',
                                'size'           => 244,
                                'cpu_hotplug'    => 'false',
                                'memory_hotplug' => 'false',
                                'server_ids'     => nil,
                                'os_type'        => 'LINUX',
                                'writeable'      => 'true',
                                'region'         => 'EUROPE',
                                'public'         => 'true'
                              },
                              { 'id'             => Fog::UUID.uuid,
                                'name'           => 'Windows-2012-R2-Server',
                                'type'           => 'HDD',
                                'size'           => 11264,
                                'cpu_hotplug'    => 'false',
                                'memory_hotplug' => 'false',
                                'server_ids'     => nil,
                                'os_type'        => 'WINDOWS',
                                'writeable'      => 'true',
                                'region'         => 'NORTH_AMERICA',
                                'public'         => 'true'
                              }
                            ],
                            :flavors => [
                              {
                                 'id'    => Fog::UUID.uuid,
                                 'name'  => 'Micro',
                                 'ram'   => 1024,
                                 'disk'  => 50,
                                 'cores' => 1
                              },
                              {
                                 'id'    => Fog::UUID.uuid,
                                 'name'  => 'Small',
                                 'ram'   => 2048,
                                 'disk'  => 50,
                                 'cores' => 1
                              }
                            ]
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
