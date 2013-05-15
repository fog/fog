require 'fog/rackspace'
require 'fog/cdn'

module Fog
  module CDN
    class Rackspace < Fog::Service
      requires :rackspace_api_key, :rackspace_username
      recognizes :rackspace_auth_url, :persistent, :rackspace_cdn_ssl, :rackspace_region, :rackspace_cdn_url

      request_path 'fog/rackspace/requests/cdn'
      request :get_containers
      request :head_container
      request :post_container
      request :put_container
      request :delete_object
      
      
      module Base
        URI_HEADERS = { 
          "X-Cdn-Ios-Uri" => :ios_uri,
          "X-Cdn-Uri" => :uri,
          "X-Cdn-Streaming-Uri" => :streaming_uri, 
          "X-Cdn-Ssl-Uri" => :ssl_uri
        }.freeze

        def service_name
          :cloudFilesCDN
        end

        def region
          @rackspace_region
        end

        def endpoint_uri(service_endpoint_url=nil)
          @uri = super(@rackspace_cdn_url || service_endpoint_url, :rackspace_cdn_url)
        end

        # Publish container to CDN
        # @param [Fog::Storage::Rackspace::Directory] container directory to publish
        # @param [Boolean] publish If true directory is published. If false directory is unpublished.
        # @return [Hash] hash containing urls for published container
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        def publish_container(container, publish = true)
          enabled = publish ? 'True' : 'False'
          response = put_container(container.key, 'X-Cdn-Enabled' => enabled)
          return {} unless publish
          urls_from_headers(response.headers)
        end
        
        # Returns hash of urls for container
        # @param [Fog::Storage::Rackspace::Directory] container to retrieve urls for
        # @return [Hash] hash containing urls for published container
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        # @note If unable to find container or container is not published this method will return an empty hash.
        def urls(container)
          begin 
            response = head_container(container.key)
            return {} unless response.headers['X-Cdn-Enabled'] == 'True'
            urls_from_headers response.headers
          rescue Fog::Service::NotFound
            {}
          end
        end
        
        private
        
        def urls_from_headers(headers)
          h = {}
          URI_HEADERS.keys.each do | header |
            key = URI_HEADERS[header]              
            h[key] = headers[header]
          end
          h
        end        
      end

      class Mock < Fog::Rackspace::Service
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
        
        def purge(object)
          return true if object.is_a? Fog::Storage::Rackspace::File            
          raise Fog::Errors::NotImplemented.new("#{object.class} does not support CDN purging") if object       
        end

        def reset_data
          self.class.data.delete(@rackspace_username)
        end
        
      end

      class Real < Fog::Rackspace::Service
        include Base

        def initialize(options={})
          @connection_options = options[:connection_options] || {}
          @rackspace_auth_url = options[:rackspace_auth_url]
          @rackspace_cdn_url = options[:rackspace_cdn_url]
          @rackspace_region = options[:rackspace_region] || :dfw
          authenticate(options)
          @enabled = false
          @persistent = options[:persistent] || false

          if endpoint_uri
            @connection = Fog::Connection.new(endpoint_uri.to_s, @persistent, @connection_options)
            @enabled = true
          end
        end

        # Returns true if CDN service is enabled
        # @return [Boolean]
        def enabled?
          @enabled
        end

        # Resets CDN connection
        def reload
          @cdn_connection.reset
        end
        
        # Purges File
        # @param [Fog::Storage::Rackspace::File] file to be purged from the CDN
        # @raise [Fog::Errors::NotImplemented] returned when non file parameters are specified
        def purge(file)
          unless file.is_a? Fog::Storage::Rackspace::File
            raise Fog::Errors::NotImplemented.new("#{object.class} does not support CDN purging")  if object
          end
          
          delete_object file.directory.key, file.key
          true
        end        

        def request(params, parse_json = true)
          begin
            response = @connection.request(params.merge!({
              :headers  => {
                'Content-Type' => 'application/json',
                'Accept' => 'application/json',
                'X-Auth-Token' => auth_token
              }.merge!(params[:headers] || {}),
              :host     => endpoint_uri.host,
              :path     => "#{endpoint_uri.path}/#{params[:path]}",
            }))
          rescue Excon::Errors::NotFound => error
            raise Fog::Storage::Rackspace::NotFound.slurp(error, region)
          rescue Excon::Errors::BadRequest => error
            raise Fog::Storage::Rackspace::BadRequest.slurp error
          rescue Excon::Errors::InternalServerError => error
            raise Fog::Storage::Rackspace::InternalServerError.slurp error
          rescue Excon::Errors::HTTPStatusError => error
            raise Fog::Storage::Rackspace::ServiceError.slurp error
          end
          if !response.body.empty? && parse_json && response.headers['Content-Type'] =~ %r{application/json}
            response.body = Fog::JSON.decode(response.body)
          end
          response
        end
        
        private 
      
        def authenticate_v1(options)
          credentials = Fog::Rackspace.authenticate(options, @connection_options)
          endpoint_uri credentials['X-CDN-Management-Url']
          @auth_token = credentials['X-Auth-Token']
        end

      end
    end
  end
end
