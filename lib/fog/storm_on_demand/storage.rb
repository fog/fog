require "fog/storm_on_demand"
require "fog/storage"

module Fog
  module Storage
    class StormOnDemand < Fog::Service

      API_URL = 'https://api.stormondemand.com'
      API_VERSION = 'v1'

      requires :storm_on_demand_username, :storm_on_demand_password
      recognizes :storm_on_demand_auth_url

      model_path 'fog/storm_on_demand/models/storage'
      model       :cluster
      collection  :clusters
      model       :volume
      collection  :volumes

      request_path 'fog/storm_on_demand/requests/storage'
      request :list_clusters
      request :attach_volume_to_server
      request :create_volume
      request :delete_volume
      request :detach_volume_from_server
      request :get_volume
      request :list_volumes
      request :resize_volume
      request :update_volume

      class Mock

        def self.data
          @data ||= Hash.new
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
              :path     => "#{@path}/#{API_VERSION}#{params[:path]}",
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
            response.body = Fog::JSON.decode(response.body)
          end
          if response.body.has_key?('error_class')
            raise(Fog::Compute::StormOnDemand::Error, response.body.inspect)
          end
          response
        end

      end
    end
  end
end
