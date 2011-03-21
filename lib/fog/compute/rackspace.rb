module Fog
  module Rackspace
    class Compute < Fog::Service

      requires :rackspace_api_key, :rackspace_username
      recognizes :rackspace_auth_url, :rackspace_servicenet, :persistent
      recognizes :provider # remove post deprecation

      model_path 'fog/compute/models/rackspace'
      model       :flavor
      collection  :flavors
      model       :image
      collection  :images
      model       :server
      collection  :servers

      request_path 'fog/compute/requests/rackspace'
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
              :images  => {},
              :servers => {}
            }
          end
        end

        def initialize(options={})
          unless options.delete(:provider)
            location = caller.first
            warning = "[yellow][WARN] Fog::Rackspace::Compute.new is deprecated, use Fog::Compute.new(:provider => 'Rackspace') instead[/]"
            warning << " [light_black](" << location << ")[/] "
            Formatador.display_line(warning)
          end

          @rackspace_username = options[:rackspace_username]
          @data = self.class.data[@rackspace_username]
        end

        def reset_data
          self.class.data.delete(@rackspace_username)
          @data = self.class.data[@rackspace_username]
        end

      end

      class Real

        def initialize(options={})
          unless options.delete(:provider)
            location = caller.first
            warning = "[yellow][WARN] Fog::Rackspace::Compute.new is deprecated, use Fog::Compute.new(:provider => 'Rackspace') instead[/]"
            warning << " [light_black](" << location << ")[/] "
            Formatador.display_line(warning)
          end

          require 'json'
          @rackspace_api_key = options[:rackspace_api_key]
          @rackspace_username = options[:rackspace_username]
          @rackspace_auth_url = options[:rackspace_auth_url]
          @rackspace_servicenet = options[:rackspace_servicenet]
          authenticate
          Excon.ssl_verify_peer = false if options[:rackspace_servicenet] == true
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", options[:persistent])
        end

        def reload
          @connection.reset
        end

        def request(params)
          begin
            response = @connection.request(params.merge!({
              :headers  => {
                'Content-Type' => 'application/json',
                'X-Auth-Token' => @auth_token
              }.merge!(params[:headers] || {}),
              :host     => @host,
              :path     => "#{@path}/#{params[:path]}",
              :query    => ('ignore_awful_caching' << Time.now.to_i.to_s)
            }))
          rescue Excon::Errors::Unauthorized => error
            if JSON.parse(response.body)['unauthorized']['message'] == 'Invalid authentication token.  Please renew.'
              authenticate
              retry
            else
              raise error
            end
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::Rackspace::Compute::NotFound.slurp(error)
            else
              error
            end
          end
          unless response.body.empty?
            response.body = JSON.parse(response.body)
          end
          response
        end

        private

        def authenticate
          options = {
            :rackspace_api_key  => @rackspace_api_key,
            :rackspace_username => @rackspace_username,
            :rackspace_auth_url => @rackspace_auth_url
          }
          credentials = Fog::Rackspace.authenticate(options)
          @auth_token = credentials['X-Auth-Token']
          uri = URI.parse(credentials['X-Server-Management-Url'])
          @host   = @rackspace_servicenet == true ? "snet-#{uri.host}" : uri.host
          @path   = uri.path
          @port   = uri.port
          @scheme = uri.scheme
        end

      end
    end
  end
end
