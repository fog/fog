require 'fog/rackspace'
require 'fog/cdn'

module Fog
  module CDN
    class Rackspace < Fog::Service

      requires :rackspace_api_key, :rackspace_username
      recognizes :rackspace_auth_url, :persistent, :rackspace_region

      request_path 'fog/rackspace/requests/cdn'
      request :get_containers
      request :head_container
      request :post_container
      request :put_container
      request :delete_object

      module Base
        private 
        
        def authentication_method
          if @rackspace_auth_url && @rackspace_auth_url =~ /v1(\.\d)?\w*$/
            :authenticate_v1
          else
           :authenticate_v2
         end
        end
        
      end


      class Mock
        include Base

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
        
        def purge(object)
          return true if object.is_a? Fog::Storage::Rackspace::File
          raise Fog::Errors::NotImplemented.new("#{object.class} does not support CDN purging") if object
        end

      end

      class Real
        include Base        

        def initialize(options={})
          @connection_options = options[:connection_options] || {}
          @rackspace_auth_url = options[:rackspace_auth_url]
          uri = authenticate(options)
          @enabled = false
          @persistent = options[:persistent] || false

          if uri
            @host   = uri.host
            @path   = uri.path
            @port   = uri.port
            @scheme = uri.scheme
            @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
            @enabled = true
          end
        end
        
        def authenticate(options)
          uri = self.send authentication_method, options
        end

        def authenticate_v2(options)
          @identity_service = Fog::Rackspace::Identity.new(options)
          @auth_token = @identity_service.auth_token
          url = @identity_service.service_catalog.get_endpoint(:cloudFilesCDN, options[:rackspace_region] || :dfw)
          URI.parse url
        end

        def authenticate_v1(options)
          credentials = Fog::Rackspace.authenticate(options, @connection_options)
          @auth_token = credentials['X-Auth-Token']
          URI.parse(credentials['X-CDN-Management-Url']) if credentials['X-CDN-Management-Url']
        end
        
        def authentication_method
          if @rackspace_auth_url && @rackspace_auth_url =~ /v1(\.\d)?\w*$/
            :authenticate_v1
          else
           :authenticate_v2
         end
        end
        
        def purge(object)
          if object.is_a? Fog::Storage::Rackspace::File
            delete_object object.directory.key, object.key
          else
            raise Fog::Errors::NotImplemented.new("#{object.class} does not support CDN purging") if object
          end
          true
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
            response.body = Fog::JSON.decode(response.body)
          end
          response
        end

      end
    end
  end
end
