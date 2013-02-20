require 'fog/rackspace'
require 'fog/rackspace/authentication'
require 'fog/cdn'

module Fog
  module CDN
    class Rackspace < Fog::Service

      requires :rackspace_api_key, :rackspace_username
      recognizes :rackspace_auth_url, :persistent, :rackspace_region, :rackspace_cdn_url

      request_path 'fog/rackspace/requests/cdn'
      request :get_containers
      request :head_container
      request :post_container
      request :put_container
      request :delete_object

      class Mock
        include Fog::Rackspace::Authentication

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
        include Fog::Rackspace::Authentication

        def initialize(options={})
          @connection_options = options[:connection_options] || {}
          @rackspace_auth_url = options[:rackspace_auth_url]
          @rackspace_cdn_url = options[:rackspace_cdn_url]
          @rackspace_region = options[:rackspace_region] || :dfw
          authenticate(options)
          @enabled = false
          @persistent = options[:persistent] || false

          if endpoint_uri
            @connection = Fog::Connection.new(endpoint_uri, @persistent, @connection_options)
            @enabled = true
          end
        end
        
        def authenticate(options)
          self.send authentication_method, options
        end     
        
        def endpoint_uri(service_endpoint_url=nil)
          return @uri if @uri
          
          url  = @rackspace_cdn_url || service_endpoint_url          
          unless url
            if v1_authentication?
              raise "Service Endpoint must be specified via :rackspace_cdn_url parameter" unless url
            else
              url = @identity_service.service_catalog.get_endpoint(:cloudFilesCDN, @rackspace_region)            
            end
          end          
          
          @uri = URI.parse url
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
              :host     => endpoint_uri.host,
              :path     => "#{endpoint_uri.path}/#{params[:path]}",
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
        
        private 
      
        def authenticate_v1(options)
          credentials = Fog::Rackspace.authenticate(options, @connection_options)
          @auth_token = credentials['X-Auth-Token']
          endpoint_uri credentials['X-CDN-Management-Url']          
        end

      end
    end
  end
end
