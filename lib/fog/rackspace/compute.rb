require 'fog/rackspace'
require 'fog/compute'

module Fog
  module Compute
    class Rackspace < Fog::Service

      requires :rackspace_api_key, :rackspace_username
      recognizes :rackspace_auth_url, :rackspace_servicenet, :persistent
      recognizes :rackspace_auth_token, :rackspace_management_url

      model_path 'fog/rackspace/models/compute'
      model       :flavor
      collection  :flavors
      model       :image
      collection  :images
      model       :server
      collection  :servers

      request_path 'fog/rackspace/requests/compute'
      request :confirm_resized_server
      request :create_image
      request :create_server
      request :delete_image
      request :delete_server
      request :get_flavor_details
      request :get_image_details
      request :get_server_details
      request :list_addresses
      request :list_private_addresses
      request :list_public_addresses
      request :list_flavors
      request :list_flavors_detail
      request :list_images
      request :list_images_detail
      request :list_servers
      request :list_servers_detail
      request :reboot_server
      request :revert_resized_server
      request :resize_server
      request :server_action
      request :update_server

      class Mock

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :last_modified => {
                :images  => {},
                :servers => {}
              },
                :servers => {},
                :images  => {
                  112 =>
                    {'id' => 112,
                      'status' => "ACTIVE",
                      'updated' => "2011-04-21T10:24:01-05:00",
                      'name' => "Ubuntu 10.04 LTS"},
                  100 =>
                    {'id' => 100,
                      'status' => "ACTIVE",
                      'updated' => "2011-09-12T09:09:23-05:00",
                      'name' => "Arch 2011.10"},
                  31 =>
                    {'id' => 31,
                      'status' => "ACTIVE",
                      'updated' => "2010-01-26T12:07:44-06:00",
                      'name' => "Windows Server 2008 SP2 x86"},
                  108 =>
                    {'id' => 108,
                      'status' => "ACTIVE",
                      'updated' => "2011-11-01T08:32:30-05:00",
                      'name' => "Gentoo 11.0"},
                  109 =>
                    {'id' => 109,
                      'status' => "ACTIVE",
                      'updated' => "2011-11-03T06:28:56-05:00",
                      'name' => "openSUSE 12"},
                  89 =>
                    {'id' => 89,
                      'status' => "ACTIVE",
                      'updated' => "2011-10-04T08:39:34-05:00",
                      'name' => "Windows Server 2008 R2 x64 - SQL2K8R2 Web"},
                  24 =>
                    {'id' => 24,
                      'status' => "ACTIVE",
                      'updated' => "2010-01-26T12:07:04-06:00",
                      'name' => "Windows Server 2008 SP2 x64"},
                  110 =>
                    {'id' => 110,
                      'status' => "ACTIVE",
                      'updated' => "2011-08-17T05:11:30-05:00",
                      'name' => "Red Hat Enterprise Linux 5.5"},
                  57 =>
                    {'id' => 57,
                      'status' => "ACTIVE",
                      'updated' => "2010-09-17T07:16:25-05:00",
                      'name' => "Windows Server 2008 SP2 x64 - MSSQL2K8R2"},
                  85 =>
                    {'id' => 85,
                      'status' => "ACTIVE",
                      'updated' => "2010-01-26T12:07:17-06:00",
                      'name' => "Windows Server 2008 R2 x64"},
                  111 =>
                    {'id' => 111,
                      'status' => "ACTIVE",
                      'updated' => "2011-09-12T10:53:12-05:00",
                      'name' => "Red Hat Enterprise Linux 6"},
                  120 =>
                    {'id' => 120,
                      'status' => "ACTIVE",
                      'updated' => "2012-01-03T04:39:05-06:00",
                      'name' => "Fedora 16"},
                  119 =>
                    {'id' => 119,
                      'status' => "ACTIVE",
                      'updated' => "2011-11-03T08:55:15-05:00",
                      'name' => "Ubuntu 11.10"},
                  116 =>
                    {'id' => 116,
                      'status' => "ACTIVE",
                      'updated' => "2011-08-17T05:11:30-05:00",
                      'name' => "Fedora 15"},
                  56 =>
                    {'id' => 56,
                      'status' => "ACTIVE",
                      'updated' => "2010-09-17T07:12:56-05:00",
                      'name' => "Windows Server 2008 SP2 x86 - MSSQL2K8R2"},
                  114 =>
                    {'id' => 114,
                      'status' => "ACTIVE",
                      'updated' => "2011-08-17T05:11:30-05:00",
                      'name' => "CentOS 5.6"},
                  86 =>
                    {'id' => 86,
                      'status' => "ACTIVE",
                      'updated' => "2010-09-17T07:19:20-05:00",
                      'name' => "Windows Server 2008 R2 x64 - MSSQL2K8R2"},
                  115 =>
                    {'id' => 115,
                      'status' => "ACTIVE",
                      'updated' => "2011-08-17T05:11:30-05:00",
                      'name' => "Ubuntu 11.04"},
                  103 =>
                    {'id' => 103,
                      'status' => "ACTIVE",
                      'updated' => "2011-08-17T05:11:30-05:00",
                      'name' => "Debian 5 (Lenny)"},
                  104 =>
                    {'id' => 104,
                      'status' => "ACTIVE",
                      'updated' => "2011-08-17T05:11:30-05:00",
                      'name' => "Debian 6 (Squeeze)"},
                  118 =>
                    {'id' => 118,
                      'status' => "ACTIVE",
                      'updated' => "2011-08-17T05:11:30-05:00",
                      'name' => "CentOS 6.0"}
                    }
              }
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          @rackspace_username = options[:rackspace_username]
        end

        def data
          self.class.data[@rackspace_username]
        end

        def reset_data
          self.class.data.delete(@rackspace_username)
        end

      end

      class Real

        def initialize(options={})
          @rackspace_api_key = options[:rackspace_api_key]
          @rackspace_username = options[:rackspace_username]
          @rackspace_auth_url = options[:rackspace_auth_url]
          @rackspace_servicenet = options[:rackspace_servicenet]
          @rackspace_auth_token = options[:rackspace_auth_token]
          @rackspace_management_url = options[:rackspace_management_url]
          @rackspace_must_reauthenticate = false
          @connection_options = options[:connection_options] || {}
          authenticate
          Excon.ssl_verify_peer = false if options[:rackspace_servicenet] == true
          @persistent = options[:persistent] || false
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
        end

        def reload
          @connection.reset
        end

        def request(params)
          begin
            response = @connection.request(params.merge({
              :headers  => {
                'Content-Type' => 'application/json',
                'X-Auth-Token' => @auth_token
              }.merge!(params[:headers] || {}),
              :host     => @host,
              :path     => "#{@path}/#{params[:path]}",
              :query    => ('ignore_awful_caching' << Time.now.to_i.to_s)
            }))
          rescue Excon::Errors::Unauthorized => error
            if error.response.body != 'Bad username or password' # token expiration
              @rackspace_must_reauthenticate = true
              authenticate
              retry
            else # bad credentials
              raise error
            end
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::Compute::Rackspace::NotFound.slurp(error)
            else
              error
            end
          end
          unless response.body.empty?
            response.body = Fog::JSON.decode(response.body)
          end
          response
        end

        private

        def authenticate
          if @rackspace_must_reauthenticate || @rackspace_auth_token.nil?
            options = {
              :rackspace_api_key  => @rackspace_api_key,
              :rackspace_username => @rackspace_username,
              :rackspace_auth_url => @rackspace_auth_url
            }
            credentials = Fog::Rackspace.authenticate(options, @connection_options)
            @auth_token = credentials['X-Auth-Token']
            uri = URI.parse(credentials['X-Server-Management-Url'])
          else
            @auth_token = @rackspace_auth_token
            uri = URI.parse(@rackspace_management_url)
          end
          @host   = @rackspace_servicenet == true ? "snet-#{uri.host}" : uri.host
          @path   = uri.path
          @port   = uri.port
          @scheme = uri.scheme
        end

      end
    end
  end
end
