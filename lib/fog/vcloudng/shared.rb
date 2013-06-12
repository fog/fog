module Fog
  module Vcloudng
    module Shared

      # Commond methods shared by Real and Mock
      module Common

        def default_organization_id
          @default_organization_id ||= begin
            org_list = get_organizations.body['OrgList']
            if org_list.length == 1
              org_list.first['href'].split('/').last
            else
              nil
            end
          end
        end

      end

      module Parser

        def parse(data)
          case data['type']
          when 'application/vnd.vmware.vcloud.vApp+xml'
            servers.new(data.merge!(:service => self))
          else
            data
          end
        end

      end

      module Real
        include Common

#        private

        def auth_token
          response = @connection.request({
            :expects   => 200,
            :headers   => { 'Authorization' => "Basic #{Base64.encode64("#{@vcloudng_username}:#{@vcloudng_password}").delete("\r\n")}",
                            'Accept' => 'application/*+xml;version=1.5'
                          },
            :host      => @host,
            :method    => 'POST',
            :parser    => Fog::Parsers::Vcloudng::Compute::GetOrganizations.new,
            :path      => "/api/sessions"  # curl http://devlab.mdsol.com/api/versions | grep LoginUrl
          })
          response.headers['Set-Cookie']
        end

        def reload
          @connection.reset
        end

        def request(params)
          unless @cookie
            @cookie = auth_token
          end
          begin
            do_request(params)
          rescue Excon::Errors::Unauthorized
            @cookie = auth_token
            do_request(params)
          end
        end

        def do_request(params)
          headers = {}
          if @cookie
            headers.merge!('Cookie' => @cookie)
          end
          if params[:path]
              if params[:override_path] == true
                  path = params[:path]
              else
                  path = "#{@path}/#{params[:path]}"
              end
          else
              path = "#{@path}"
          end
          @connection.request({
            :body     => params[:body],
            :expects  => params[:expects],
            :headers  => headers.merge!(params[:headers] || {}),
            :host     => @host,
            :method   => params[:method],
            :parser   => params[:parser],
            :path     => path
          })
        end

      end

      module Mock
        include Common

        def self.mock_data
        {
          :organizations =>
          [
            {
              :info => {
                :name => "Boom Inc.",
                :id => 1
              },
              :vdcs => [
                { :id => 21,
                  :name => "Boomstick",
                  :storage => { :used => 105, :allocated => 200 },
                  :cpu => { :allocated => 10000 },
                  :memory => { :allocated => 20480 },
                  :networks => [
                    { :id => 31,
                      :name => "1.2.3.0/24",
                      :subnet => "1.2.3.0/24",
                      :gateway => "1.2.3.1",
                      :netmask => "255.255.255.0",
                      :fencemode => "isolated"
                    },
                    { :id => 32,
                      :name => "4.5.6.0/24",
                      :subnet => "4.5.6.0/24",
                      :gateway => "4.5.6.1",
                      :netmask => "255.255.255.0",
                      :fencemode => "isolated"
                    },
                  ],
                  :vms => [
                    { :id => 41,
                      :name => "Broom 1"
                    },
                    { :id => 42,
                      :name => "Broom 2"
                    },
                    { :id => 43,
                      :name => "Email!"
                    }
                  ],
                  :public_ips => [
                    { :id => 51,
                      :name => "99.1.2.3"
                    },
                    { :id => 52,
                      :name => "99.1.2.4"
                    },
                    { :id => 53,
                      :name => "99.1.9.7"
                    }
                  ]
                },
                { :id => 22,
                  :storage => { :used => 40, :allocated => 150 },
                  :cpu => { :allocated => 1000 },
                  :memory => { :allocated => 2048 },
                  :name => "Rock-n-Roll",
                  :networks => [
                    { :id => 33,
                      :name => "7.8.9.0/24",
                      :subnet => "7.8.9.0/24",
                      :gateway => "7.8.9.1",
                      :netmask => "255.255.255.0",
                      :fencemode => "isolated"
                    }
                  ],
                  :vms => [
                    { :id => 44,
                      :name => "Master Blaster"
                    }
                  ],
                  :public_ips => [
                    { :id => 54,
                      :name => "99.99.99.99"
                    }
                  ]
                }
              ]
            }
          ]
        }
        end

        def self.error_headers
          {"X-Powered-By"=>"ASP.NET",
           "Date"=> Time.now.to_s,
           "Content-Type"=>"text/html",
           "Content-Length"=>"0",
           "Server"=>"Microsoft-IIS/7.0",
           "Cache-Control"=>"private"}
        end

        def self.unathorized_status
          401
        end

        def self.headers(body, content_type)
          {"X-Powered-By"=>"ASP.NET",
           "Date"=> Time.now.to_s,
           "Content-Type"=> content_type,
           "Content-Length"=> body.to_s.length,
           "Server"=>"Microsoft-IIS/7.0",
           "Set-Cookie"=>"vcloud-token=ecb37bfc-56f0-421d-97e5-bf2gdf789457; path=/",
           "Cache-Control"=>"private"}
        end

        def self.status
          200
        end

        def initialize(options={})
          self.class.instance_eval '
            def self.data
              @data ||= Hash.new do |hash, key|
                hash[key] = Fog::Vcloudng::Compute::Mock.mock_data
              end
            end'
          self.class.instance_eval '
            def self.reset
              @data = nil
            end

            def self.reset_data(keys=data.keys)
              for key in [*keys]
                data.delete(key)
              end
            end'
        end
      end

      def check_shared_options(options)
          cloud_option_keys = options.keys.select { |key| key.to_s =~ /^vcloudng_.*/ }
          unless cloud_option_keys.length == 0 || cloud_option_keys.length == 3
            raise ArgumentError.new("vcloudng_username, vcloudng_password and vcloudng_host required to access vcloud")
          end
      end

      def shared_requires
        #require 'fog/vcloudng/models/compute/address'
        #require 'fog/vcloudng/models/compute/addresses'
        #require 'fog/vcloudng/models/compute/network'
        #require 'fog/vcloudng/models/compute/networks'
        #require 'fog/vcloudng/models/compute/server'
        #require 'fog/vcloudng/models/compute/servers'
        #require 'fog/vcloudng/models/compute/image'
        #require 'fog/vcloudng/models/compute/images'
        #require 'fog/vcloudng/models/compute/task'
        #require 'fog/vcloudng/models/compute/tasks'
        #require 'fog/vcloudng/models/compute/vdc'
        #require 'fog/vcloudng/models/compute/vdcs'
        #require 'fog/vcloudng/models/compute/internetservice'
        #require 'fog/vcloudng/models/compute/internetservices'
        #require 'fog/vcloudng/models/compute/nodeservice'
        #require 'fog/vcloudng/models/compute/nodeservices'
        #require 'fog/vcloudng/parsers/compute/get_internet_services'
        #require 'fog/vcloudng/parsers/compute/get_network_ips'
        #require 'fog/vcloudng/parsers/compute/get_node_services'
        #require 'fog/vcloudng/parsers/compute/get_public_ips'
        #require 'fog/vcloudng/parsers/compute/get_tasks_list'
        #require 'fog/vcloudng/parsers/compute/get_keys_list'
        #require 'fog/vcloudng/parsers/compute/instantiate_vapp_template'
        #require 'fog/vcloudng/parsers/compute/internet_service'
        #require 'fog/vcloudng/parsers/compute/network'
        #require 'fog/vcloudng/parsers/compute/node_service'
        #require 'fog/vcloudng/parsers/compute/public_ip'
        #require 'fog/vcloudng/parsers/compute/task'
        #require 'fog/vcloudng/parsers/compute/vapp'
        #require 'fog/vcloudng/requests/compute/add_internet_service'
        #require 'fog/vcloudng/requests/compute/add_node_service'
        #require 'fog/vcloudng/requests/compute/create_internet_service'
        #require 'fog/vcloudng/requests/compute/delete_internet_service'
        #require 'fog/vcloudng/requests/compute/delete_public_ip'
        #require 'fog/vcloudng/requests/compute/delete_node_service'
        #require 'fog/vcloudng/requests/compute/delete_vapp'
        #require 'fog/vcloudng/requests/compute/deploy_vapp'
        require 'fog/vcloudng/requests/compute/get_catalog'
        require 'fog/vcloudng/requests/compute/get_catalog_item'
        #require 'fog/vcloudng/requests/compute/get_internet_services'
        #require 'fog/vcloudng/requests/compute/get_network'
        #require 'fog/vcloudng/requests/compute/get_network_ips'
        #require 'fog/vcloudng/requests/compute/get_node_services'
        require 'fog/vcloudng/requests/compute/get_organization'
        require 'fog/vcloudng/requests/compute/get_organizations'
        #require 'fog/vcloudng/requests/compute/get_public_ip'
        #require 'fog/vcloudng/requests/compute/get_public_ips'
        #require 'fog/vcloudng/requests/compute/get_task'
        #require 'fog/vcloudng/requests/compute/get_tasks_list'
        #require 'fog/vcloudng/requests/compute/get_keys_list'
        #require 'fog/vcloudng/requests/compute/get_vapp'
        require 'fog/vcloudng/requests/compute/get_vapp_template'
        #require 'fog/vcloudng/requests/compute/instantiate_vapp_template'
        require 'fog/vcloudng/requests/compute/get_vdc'
        #require 'fog/vcloudng/requests/compute/configure_vapp'
        #require 'fog/vcloudng/requests/compute/power_off'
        #require 'fog/vcloudng/requests/compute/power_on'
        #require 'fog/vcloudng/requests/compute/power_reset'
        #require 'fog/vcloudng/requests/compute/power_shutdown'
      end

    end
  end
end
