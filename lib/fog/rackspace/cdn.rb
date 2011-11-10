require File.expand_path(File.join(File.dirname(__FILE__), '..', 'rackspace'))
require 'fog/cdn'

module Fog
  module CDN
    class Rackspace < Fog::Service

      requires :rackspace_api_key, :rackspace_username
      recognizes :rackspace_auth_url, :persistent

      model_path 'fog/rackspace/models/cdn'

      request_path 'fog/rackspace/requests/cdn'
      request :get_containers
      request :head_container
      request :post_container
      request :put_container

      class Mock

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {}
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
          require 'multi_json'
          @connection_options = options[:connection_options] || {}
          credentials = Fog::Rackspace.authenticate(options, @connection_options)
          @auth_token = credentials['X-Auth-Token']
          @enabled = false
          @persistent = options[:persistent] || false

          if credentials['X-CDN-Management-Url']
            uri = URI.parse(credentials['X-CDN-Management-Url'])
            @host   = uri.host
            @path   = uri.path
            @port   = uri.port
            @scheme = uri.scheme
            @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
            @enabled = true
          end
        end

        def enabled?
          @enabled
        end

        def reload
          @cdn_connection.reset
        end

        def request(params, parse_json = true)
          begin
            response = @connection.request(params.merge!({
              :headers  => {
                'Content-Type' => 'application/json',
                'X-Auth-Token' => @auth_token
              }.merge!(params[:headers] || {}),
              :host     => @host,
              :path     => "#{@path}/#{params[:path]}",
            }))
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::Storage::Rackspace::NotFound.slurp(error)
            else
              error
            end
          end
          if !response.body.empty? && parse_json && response.headers['Content-Type'] =~ %r{application/json}
            response.body = MultiJson.decode(response.body)
          end
          response
        end

      end
    end
  end
end
