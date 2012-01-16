module Fog
  module Compute
    class Clodo < Fog::Service

      requires :clodo_api_key, :clodo_username
      recognizes :clodo_auth_url, :persistent
      recognizes :clodo_auth_token, :clodo_management_url

      model_path 'fog/clodo/models/compute'
      model       :image
      collection  :images
      model       :server
      collection  :servers

      request_path 'fog/clodo/requests/compute'
      request :create_server
      request :delete_server
      request :get_image_details # Not supported by API
      request :list_images
      request :list_images_detail
      request :list_servers
      request :list_servers_detail
      request :get_server_details
      request :server_action
      request :start_server
      request :stop_server
      request :reboot_server
      request :rebuild_server
      request :add_ip_address
      request :delete_ip_address
      request :move_ip_address
      # request :list_addresses
      # request :list_private_addresses
      # request :list_public_addresses
      # request :confirm_resized_server
      # request :revert_resized_server
      # request :resize_server
      # request :update_server

      class Mock

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :last_modified => {
                :images  => {},
                :servers => {}
              },
              :images  => {},
              :servers => {}
            }
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          require 'multi_json'
          @clodo_username = options[:clodo_username]
        end

        def data
          self.class.data[@clodo_username]
        end

        def reset_data
          self.class.data.delete(@clodo_username)
        end

      end

      class Real

        def initialize(options={})
          require 'multi_json'
          @clodo_api_key = options[:clodo_api_key]
          @clodo_username = options[:clodo_username]
          @clodo_auth_url = options[:clodo_auth_url]
          @clodo_servicenet = options[:clodo_servicenet]
          @clodo_auth_token = options[:clodo_auth_token]
          @clodo_management_url = options[:clodo_management_url]
          @clodo_must_reauthenticate = false
          authenticate
          Excon.ssl_verify_peer = false if options[:clodo_servicenet] == true
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", options[:persistent])
        end

        def reload
          @connection.reset
        end

        def request(params)
          begin
            response = @connection.request(params.merge({
              :headers  => {
                'Content-Type' => 'application/json',
                'Accept' => 'application/json',
                'X-Auth-Token' => @auth_token
              }.merge!(params[:headers] || {}),
              :host     => @host,
              :path     => "#{@path}/#{params[:path]}"
            }))
          rescue Excon::Errors::Unauthorized => error
            if error.response.body != 'Bad username or password' # token expiration
              @clodo_must_reauthenticate = true
              authenticate
              retry
            else # bad credentials
              raise error
            end
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::Compute::Clodo::NotFound.slurp(error)
            else
              error
            end
          end
          unless response.body.empty?
            response.body = MultiJson.decode(response.body)
          end
          response
        end

        private

        def authenticate
          if @clodo_must_reauthenticate || @clodo_auth_token.nil?
            options = {
              :clodo_api_key  => @clodo_api_key,
              :clodo_username => @clodo_username,
              :clodo_auth_url => @clodo_auth_url
            }
            credentials = Fog::Clodo.authenticate(options)
            @auth_token = credentials['X-Auth-Token']
            uri = URI.parse(credentials['X-Server-Management-Url'])
          else
            @auth_token = @clodo_auth_token
            uri = URI.parse(@clodo_management_url)
          end
          @host   = @clodo_servicenet == true ? "snet-#{uri.host}" : uri.host
          @path   = uri.path
          @port   = uri.port
          @scheme = uri.scheme
        end

      end
    end
  end
end
