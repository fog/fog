require 'fog/rackspace'
require 'fog/cdn'

module Fog
  module CDN
    class Rackspace < Fog::Service

      requires :rackspace_api_key, :rackspace_username
      recognizes :rackspace_auth_url, :persistent, :rackspace_cdn_ssl

      request_path 'fog/rackspace/requests/cdn'
      request :get_containers
      request :head_container
      request :post_container
      request :put_container
      request :delete_object
      
      
      module Base
        def ssl?
          !@rackspace_cdn_ssl.nil?
        end
        
        def purge(file)
          unless file.is_a? Fog::Storage::Rackspace::File
            raise Fog::Errors::NotImplemented.new("#{object.class} does not support CDN purging")
          end
          
          delete_object file.directory.key, file.key
          true
        end

        def publish_container(container, publish = true)
          enabled = publish ? 'True' : 'False'
          response = put_container(container.key, 'X-CDN-Enabled' => enabled)
          url_from_headers(response.headers, container.cdn_cname)
        end
        
        def public_url(container)
          begin 
            response = head_container(container.key)
            if response.headers['X-Cdn-Enabled'] == 'True'
              url_from_headers(response.headers, container.cdn_cname)
            else
              nil
            end
          rescue Fog::Service::NotFound
            nil
          end
        end
        
        private
        
        def url_from_headers(headers, cdn_cname)
          return nil unless headers['X-Cdn-Enabled']
          return headers['X-Cdn-Ssl-Uri'] if ssl?
          cdn_cname || headers['X-Cdn-Uri']
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
        
      end

      class Real
        include Base
        
        def initialize(options={})
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
            response.body = Fog::JSON.decode(response.body)
          end
          response
        end

      end
    end
  end
end
