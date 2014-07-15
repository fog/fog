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
                        Fog::ProfitBricks.parse_error(error.response.body)
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
                            :datacenters     => [{ 
                              'requestId'         => Fog::Mock::random_numbers(7),
                              'dataCenterId'      => Fog::UUID.uuid,
                              'dataCenterName'    => 'MockDC',
                              'provisioningState' => 'AVAILABLE',
                              'dataCenterVersion' => 1,
                              'region'            => 'NORTH_AMERICA'
                            }]
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
