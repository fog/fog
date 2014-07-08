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
            model        :data_center
            collection   :data_centers

            # Requests - server
            request_path 'fog/profitbricks/requests/compute'
            request      :create_server        # createServer
            request      :delete_server        # deleteServer
            request      :get_all_servers      # getAllServers
            request      :get_server           # getServer
            request      :reset_server         # resetServer
            request      :start_server         # startServer
            request      :stop_server          # stopServer
            request      :update_server        # updateServer

            request      :clear_data_center    # clearDataCenter
            request      :create_data_center   # createDataCenter
            request      :delete_data_center   # deleteDataCenter
            request      :get_all_data_centers # getAllDataCenters
            request      :get_data_center      # getDataCenter
            request      :update_data_center   # updateDataCenter

            class Real
                def initialize(options={})
                    @profitbricks_username = options[:profitbricks_username]
                    @profitbricks_password = options[:profitbricks_password]
                    @profitbricks_url      = options[:profitbricks_url] || 'https://api.profitbricks.com/1.2'

                    #@connection = Fog::XML::Connection.new('https://api.profitbricks.com/1.2', false)
                    @connection = Fog::Core::Connection.new(@profitbricks_url, false)
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
                    end

                    return parse(response)
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
                            :servers => [],
                            :ssh_keys => []
                        }
                    end
                end

                def self.reset
                    @data = nil
                end

                def initialize(options={})
                end

                def data
                end

                def reset_data
                end
            end
        end
    end
end
