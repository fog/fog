require File.expand_path(File.join(File.dirname(__FILE__), '..', 'storm_on_demand'))
require 'fog/compute'

module Fog
  module Compute
    class StormOnDemand < Fog::Service

      API_URL = 'https://api.stormondemand.com'

      requires :storm_on_demand_username, :storm_on_demand_password
      recognizes :storm_on_demand_auth_url

      model_path 'fog/storm_on_demand/models/compute'
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

      request_path 'fog/storm_on_demand/requests/compute'
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
      request :get_stats
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

        def self.reset
          @data = nil
        end

        def self.reset_data(keys=data.keys)
          for key in [*keys]
            data.delete(key)
          end
        end

        def initialize(options={})
          @storm_on_demand_username = options[:storm_on_demand_username]
        end

        def data
          self.class.data[@storm_on_demand_username]
        end

        def reset_data
          self.class.data.delete(@storm_on_demand_username)
        end

      end

      class Real

        def initialize(options={})
          require 'multi_json'
          uri = URI.parse(options[:storm_on_demand_auth_url] ||= API_URL)
          @connection_options = options[:connection_options] || {}
          @host       = uri.host
          @path       = uri.path
          @persistent = options[:persistent] || false
          @port       = uri.port
          @scheme     = uri.scheme
          @storm_on_demand_username = options[:storm_on_demand_username]
          @storm_on_demand_password = options[:storm_on_demand_password]
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
        end

        def reload
          @connection.reset
        end

        def request(params)
          begin
            response = @connection.request(params.merge!({
              :headers  => {
                'Content-Type' => 'application/json',
                'Authorization' => 'Basic ' << Base64.encode64("#{@storm_on_demand_username}:#{@storm_on_demand_password}").chomp
              }.merge!(params[:headers] || {}),
              :host     => @host,
              :path     => "#{@path}/#{params[:path]}",
              :expects  => 200,
              :method   => :post
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
            response.body = MultiJson.decode(response.body)
          end
          if response.body.has_key?('full_error')
            raise(Fog::Compute::StormOnDemand::Error, response.body.inspect)
          end
          response
        end

      end
    end
  end
end
