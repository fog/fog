module Fog
  module Rackspace
    class Storage < Fog::Service

      requires :rackspace_api_key, :rackspace_username
      recognizes :rackspace_auth_url, :rackspace_servicenet, :rackspace_cdn_ssl, :persistent
      recognizes :provider # remove post deprecation

      model_path 'fog/storage/models/rackspace'
      model       :directory
      collection  :directories
      model       :file
      collection  :files

      request_path 'fog/storage/requests/rackspace'
      request :delete_container
      request :delete_object
      request :get_container
      request :get_containers
      request :get_object
      request :head_container
      request :head_containers
      request :head_object
      request :put_container
      request :put_object

      module Utils

        def cdn
          @cdn ||= Fog::CDN.new(
            :provider           => 'Rackspace',
            :rackspace_api_key  => @rackspace_api_key,
            :rackspace_username => @rackspace_username
          )
        end

      end

      class Mock
        include Utils

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {}
          end
        end

        def initialize(options={})
          unless options.delete(:provider)
            location = caller.first
            warning = "[yellow][WARN] Fog::Rackspace::Storage.new is deprecated, use Fog::Storage.new(:provider => 'Rackspace') instead[/]"
            warning << " [light_black](" << location << ")[/] "
            Formatador.display_line(warning)
          end

          require 'mime/types'
          @rackspace_api_key = options[:rackspace_api_key]
          @rackspace_username = options[:rackspace_username]
          @data = self.class.data[@rackspace_username]
        end

        def reset_data
          self.class.data.delete(@rackspace_username)
          @data = self.class.data[@rackspace_username]
        end

      end

      class Real
        include Utils
        attr_reader :rackspace_cdn_ssl

        def initialize(options={})
          unless options.delete(:provider)
            location = caller.first
            warning = "[yellow][WARN] Fog::Rackspace::Storage.new is deprecated, use Fog::Storage.new(:provider => 'Rackspace') instead[/]"
            warning << " [light_black](" << location << ")[/] "
            Formatador.display_line(warning)
          end

          require 'mime/types'
          require 'json'
          @rackspace_api_key = options[:rackspace_api_key]
          @rackspace_username = options[:rackspace_username]
          @rackspace_cdn_ssl = options[:rackspace_cdn_ssl]
          credentials = Fog::Rackspace.authenticate(options)
          @auth_token = credentials['X-Auth-Token']

          uri = URI.parse(credentials['X-Storage-Url'])
          @host   = options[:rackspace_servicenet] == true ? "snet-#{uri.host}" : uri.host
          @path   = uri.path
          @port   = uri.port
          @scheme = uri.scheme
          Excon.ssl_verify_peer = false if options[:rackspace_servicenet] == true
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", options[:persistent])
        end

        def reload
          @storage_connection.reset
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
              Fog::Rackspace::Storage::NotFound.slurp(error)
            else
              error
            end
          end
          if !response.body.empty? && parse_json && response.headers['Content-Type'] =~ %r{application/json}
            response.body = JSON.parse(response.body)
          end
          response
        end

      end
    end
  end
end
