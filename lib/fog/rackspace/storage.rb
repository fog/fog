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
      request :get_object_http_url
      request :head_container
      request :head_containers
      request :head_object
      request :put_container
      request :put_object
      request :put_object_manifest
      request :put_dynamic_obj_manifest
      request :put_static_obj_manifest
      request :post_set_meta_temp_url_key

      module Common
        def apply_options(options)
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
          @connection_options = options[:connection_options] || {}
        end

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
      end

      class Mock < Fog::Rackspace::Service
        include Common

        class MockContainer
          attr_reader :objects, :meta

          def initialize
            @objects, @meta = {}, {}
          end

          def empty?
            @objects.empty?
          end

          def bytes_used
            @objects.values.map { |o| o.size }.inject(0) { |a, b| a + b }
          end

          def headers
            @meta.merge({
              'X-Container-Object-Count' => @objects.size,
              'X-Container-Bytes-Used' => bytes_used
            })
          end

          def mock_object name
            @objects[Fog::Rackspace.escape(name)]
          end

          def mock_object! name
            mock_object(name) or raise Fog::Storage::Rackspace::NotFound.new
          end

          def add_object name, data
            @objects[Fog::Rackspace.escape(name)] = MockObject.new(data)
          end

          def remove_object name
            @objects.delete Fog::Rackspace.escape(name)
          end
        end

        class MockObject
          attr_reader :hash, :bytes, :content_type, :last_modified
          attr_reader :body, :meta

          def initialize data
            data = Fog::Storage.parse_data(data)

            @bytes = data[:headers]['Content-Length']
            @content_type = data[:headers]['Content-Type']
            if data[:body].respond_to? :read
              @body = data[:body].read
            else
              @body = data[:body]
            end
            @last_modified = Time.now.utc
            @hash = Base64.encode64(Digest::MD5.digest(@body)).strip
            @meta = {}
          end

          def to_headers
            {
              'Content-Type' => @content_type,
              'Content-Length' => @bytes,
              'Last-Modified' => @last_modified.strftime('%a, %b %d %Y %H:%M:%S %Z'),
              'ETag' => @hash
            }.merge(@meta)
          end
        end

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {}
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          apply_options(options)
          authenticate
          endpoint_uri
        end

        def data
          self.class.data[@rackspace_username]
        end

        def reset_data
          self.class.data.delete(@rackspace_username)
        end

        def mock_container cname
          data[Fog::Rackspace.escape(cname)]
        end

        def mock_container! cname
          mock_container(cname) or raise Fog::Storage::Rackspace::NotFound.new
        end

        def remove_container cname
          data.delete Fog::Rackspace.escape(cname)
        end

        def ssl?
          !!@rackspace_cdn_ssl
        end
      end

      class Real < Fog::Rackspace::Service
        include Common

        attr_reader :rackspace_cdn_ssl

        def initialize(options={})
          apply_options(options)

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

        def request(params, parse_json = true)
          super
        rescue Excon::Errors::NotFound => error
          raise NotFound.slurp(error, self)
        rescue Excon::Errors::BadRequest => error
          raise BadRequest.slurp(error, self)
        rescue Excon::Errors::InternalServerError => error
          raise InternalServerError.slurp(error, self)
        rescue Excon::Errors::HTTPStatusError => error
          raise ServiceError.slurp(error, self)
        end

        def endpoint_uri(service_endpoint_url=nil)
          return @uri if @uri
          super(@rackspace_storage_url || service_endpoint_url, :rackspace_storage_url)
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
