module Fog
  module Stormondemand
    class Compute < Fog::Service
      
      API_URL = 'https://api.stormondemand.com'
      
      requires :stormondemand_username, :stormondemand_password
      recognizes :stormondemand_auth_url
      recognizes :provider # remove post deprecation

      model_path 'fog/compute/models/stormondemand'
      model       :config
      collection  :configs
      model       :image
      collection  :images
      model       :server
      collection  :servers
      model       :balancer
      collection  :balancers
      model       :private_ip
      collection  :private_ips
      model       :stat
      collection  :stats
      model       :template
      collection  :templates

      request_path 'fog/compute/requests/stormondemand'
      request :clone_server
      request :delete_server
      request :reboot_server
      request :list_servers
      request :get_server
      request :create_server
      request :resize_server
      request :remove_balancer_node
      request :add_balancer_node
      request :list_balancers
      request :list_configs
      request :list_templates
      request :list_images
      
      # possibly broken, needs testing with monitored instance
      request :get_stats
      
      # broken:
      request :list_private_ips      
      
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

        def self.reset_data(keys=data.keys)
          for key in [*keys]
            data.delete(key)
          end
        end

        def initialize(options={})
          @stormondemand_username = options[:stormondemand_username]
          @data = self.class.data[@stormondemand_username]
        end

      end

      class Real

        def initialize(options={})
          require 'json'
          uri = URI.parse(options[:stormondemand_auth_url] ||= API_URL)
          @host   = uri.host
          @path   = uri.path
          @port   = uri.port
          @scheme = uri.scheme
          @stormondemand_username = options[:stormondemand_username]
          @stormondemand_password = options[:stormondemand_password]
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}")
        end

        def reload
          @connection.reset
        end

        def request(params)
          begin
            response = @connection.request(params.merge!({
              :headers  => {
                'Content-Type' => 'application/json',
                'Authorization' => "Basic " + Base64.encode64("#{@stormondemand_username}:#{@stormondemand_password}").chomp
              }.merge!(params[:headers] || {}),
              :host     => @host,
              :path     => "#{@path}/#{params[:path]}"
            }))
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::StormOnDemand::Compute::NotFound.slurp(error)
            else
              error
            end
          end
          unless response.body.empty?
            response.body = JSON.parse(response.body)
          end
          if response.body.keys[0] == 'error_class'
            raise Fog::Stormondemand::Compute::Error, response.body.inspect
          end
          response
        end

      end
    end
  end
end
