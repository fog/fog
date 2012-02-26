require File.expand_path(File.join(File.dirname(__FILE__), '..', 'rackspace'))
require 'fog/storage'

module Fog
  module Storage
    class Rackspace < Fog::Service

      requires :rackspace_api_key, :rackspace_username
      recognizes :rackspace_auth_url, :rackspace_servicenet, :rackspace_cdn_ssl, :persistent

      model_path 'fog/rackspace/models/storage'
      model       :directory
      collection  :directories
      model       :file
      collection  :files

      request_path 'fog/rackspace/requests/storage'
      request :copy_object
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
      request :put_object_manifest

      module Utils

        def cdn
          @cdn ||= Fog::CDN.new(
            :provider           => 'Rackspace',
            :rackspace_api_key  => @rackspace_api_key,
            :rackspace_auth_url => @rackspace_auth_url,
            :rackspace_username => @rackspace_username
          )
          if @cdn.enabled?
            @cdn
          end
        end

      end

      class Mock
        include Utils

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {}
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          require 'mime/types'
          @rackspace_api_key = options[:rackspace_api_key]
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
        include Utils
        attr_reader :rackspace_cdn_ssl

        def initialize(options={})
          require 'mime/types'
          require 'multi_json'
          @rackspace_api_key = options[:rackspace_api_key]
          @rackspace_username = options[:rackspace_username]
          @rackspace_cdn_ssl = options[:rackspace_cdn_ssl]
          @rackspace_auth_url = options[:rackspace_auth_url]
          @connection_options     = options[:connection_options] || {}
          credentials = Fog::Rackspace.authenticate(options, @connection_options)
          @auth_token = credentials['X-Auth-Token']

          uri = URI.parse(credentials['X-Storage-Url'])
          @host       = options[:rackspace_servicenet] == true ? "snet-#{uri.host}" : uri.host
          @path       = uri.path
          @persistent = options[:persistent] || false
          @port       = uri.port
          @scheme     = uri.scheme
          Excon.ssl_verify_peer = false if options[:rackspace_servicenet] == true
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
        end

        def reload
          @connection.reset
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
