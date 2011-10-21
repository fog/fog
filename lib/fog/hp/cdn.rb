require File.expand_path(File.join(File.dirname(__FILE__), '..', 'hp'))
require 'fog/cdn'

module Fog
  module CDN
    class HP < Fog::Service

      requires    :hp_secret_key, :hp_account_id
      recognizes  :hp_auth_uri, :persistent, :connection_options

      model_path   'fog/hp/models/cdn'

      request_path 'fog/hp/requests/cdn'
      request :get_containers
      request :head_container
      request :post_container
      request :put_container
      request :delete_container

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
          @hp_account_id = options[:hp_account_id]
        end

        def data
          self.class.data[@hp_account_id]
        end

        def reset_data
          self.class.data.delete(@hp_account_id)
        end

      end

      class Real

        def initialize(options={})
          require 'multi_json'
          @connection_options = options[:connection_options] || {}
          credentials = Fog::HP.authenticate(options, @connection_options)
          @auth_token = credentials['X-Auth-Token']
          @enabled = false
          @persistent = options[:persistent] || false

          #TODO: Fix hardcoded urls when CDN-64 and CDN-65 are fixed
          if credentials['X-Storage-Url']   #credentials['X-CDN-Management-Url']
            uri = URI.parse(credentials['X-Storage-Url'])     #URI.parse(credentials['X-CDN-Management-Url'])
            @host   = URI.parse(options[:hp_auth_uri]).host   #uri.host
            @path   = uri.path
            @port   = URI.parse(options[:hp_auth_uri]).port   #uri.port
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

        def request(params, parse_json = true, &block)
          begin
            response = @connection.request(params.merge!({
              :headers  => {
                'Content-Type' => 'application/json',
                'X-Auth-Token' => @auth_token
              }.merge!(params[:headers] || {}),
              :host     => @host,
              :path     => "#{@path}/#{params[:path]}",
            }), &block)
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::Storage::HP::NotFound.slurp(error)
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
