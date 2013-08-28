require 'fog/rackspace'
require 'fog/storage'

module Fog
  module Storage
    class Rackspace < Fog::Service
      include Fog::Rackspace::Errors

      class ServiceError < Fog::Rackspace::Errors::ServiceError; end
      class InternalServerError < Fog::Rackspace::Errors::InternalServerError; end
      class BadRequest < Fog::Rackspace::Errors::BadRequest; end

      requires :rackspace_api_key, :rackspace_username
      recognizes :rackspace_auth_url, :rackspace_servicenet, :rackspace_cdn_ssl, :persistent, :rackspace_region
      recognizes :rackspace_temp_url_key, :rackspace_storage_url, :rackspace_cdn_url

      model_path 'fog/rackspace/models/storage'
      model       :directory
      collection  :directories
      model       :file
      collection  :files
      model       :account

      request_path 'fog/rackspace/requests/storage'
      request :copy_object
      request :delete_container
      request :delete_object
      request :delete_static_large_object
      request :delete_multiple_objects
      request :get_container
      request :get_containers
      request :get_object
      request :get_object_https_url
      request :head_container
      request :head_containers
      request :head_object
      request :put_container
      request :put_object
      request :put_object_manifest
      request :put_dynamic_obj_manifest
      request :put_static_obj_manifest
      request :post_set_meta_temp_url_key

      module Utils

        def cdn
          @cdn ||= Fog::CDN.new(
            :provider           => 'Rackspace',
            :rackspace_api_key  => @rackspace_api_key,
            :rackspace_auth_url => @rackspace_auth_url,
            :rackspace_cdn_url => @rackspace_cdn_url,
            :rackspace_username => @rackspace_username,
            :rackspace_region => @rackspace_region,
            :rackspace_cdn_ssl => @rackspace_cdn_ssl
          )
          if @cdn.enabled?
            @cdn
          end
        end

      end

      class Mock < Fog::Rackspace::Service
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
          @rackspace_api_key = options[:rackspace_api_key]
          @rackspace_username = options[:rackspace_username]
          @rackspace_cdn_ssl = options[:rackspace_cdn_ssl]
        end

        def data
          self.class.data[@rackspace_username]
        end

        def reset_data
          self.class.data.delete(@rackspace_username)
        end

        def service_name
          :cloudFiles
        end

        def region
          @rackspace_region
        end

        def ssl?
          !!@rackspace_cdn_ssl
        end

      end

      class Real < Fog::Rackspace::Service
        include Utils

        attr_reader :rackspace_cdn_ssl

        def initialize(options={})
          @rackspace_api_key = options[:rackspace_api_key]
          @rackspace_username = options[:rackspace_username]
          @rackspace_cdn_ssl = options[:rackspace_cdn_ssl]
          @rackspace_auth_url = options[:rackspace_auth_url]
          @rackspace_servicenet = options[:rackspace_servicenet]
          @rackspace_auth_token = options[:rackspace_auth_token]
          @rackspace_storage_url = options[:rackspace_storage_url]
          @rackspace_cdn_url = options[:rackspace_cdn_url]
          @rackspace_region = options[:rackspace_region] || :dfw
          @rackspace_temp_url_key = options[:rackspace_temp_url_key]
          @rackspace_must_reauthenticate = false
          @connection_options     = options[:connection_options] || {}

          authenticate
          @persistent = options[:persistent] || false
          Excon.defaults[:ssl_verify_peer] = false if service_net?
          @connection = Fog::Connection.new(endpoint_uri.to_s, @persistent, @connection_options)
        end

        # Return Account Details
        # @return [Fog::Storage::Rackspace::Account] account details object
        def account
          account = Fog::Storage::Rackspace::Account.new(:service => self)
          account.reload
        end

        # Using SSL?
        # @return [Boolean] return true if service is returning SSL-Secured URLs in public_url methods
        # @see Directory#public_url
        def ssl?
          !!rackspace_cdn_ssl
        end

        # Resets presistent service connections
        def reload
          @connection.reset
        end

        def request(params, parse_json = true, &block)
          super(params, parse_json, &block)
        rescue Excon::Errors::NotFound => error
          raise NotFound.slurp(error, self)
        rescue Excon::Errors::BadRequest => error
          raise BadRequest.slurp(error, self)
        rescue Excon::Errors::InternalServerError => error
          raise InternalServerError.slurp(error, self)
        rescue Excon::Errors::HTTPStatusError => error
          raise ServiceError.slurp(error, self)
        end

        def service_net?
          @rackspace_servicenet == true
        end

        def authenticate
          if @rackspace_must_reauthenticate || @rackspace_auth_token.nil?
            options = {
              :rackspace_api_key  => @rackspace_api_key,
              :rackspace_username => @rackspace_username,
              :rackspace_auth_url => @rackspace_auth_url,
              :connection_options => @connection_options
            }
            super(options)
          else
            @auth_token = @rackspace_auth_token
            @uri = URI.parse(@rackspace_storage_url)
          end
        end

        def service_name
          :cloudFiles
        end

        def request_id_header
          "X-Trans-Id"
        end

        def region
          @rackspace_region
        end

        def endpoint_uri(service_endpoint_url=nil)
          return @uri if @uri

          @uri = super(@rackspace_storage_url || service_endpoint_url, :rackspace_storage_url)
          @uri.host = "snet-#{@uri.host}" if service_net?
          @uri
        end

        private

        def authenticate_v1(options)
          credentials = Fog::Rackspace.authenticate(options, @connection_options)
          endpoint_uri credentials['X-Storage-Url']
          @auth_token = credentials['X-Auth-Token']
        end

      end
    end
  end
end
