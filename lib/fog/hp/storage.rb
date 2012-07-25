require 'fog/hp'
require 'fog/storage'

module Fog
  module Storage
    class HP < Fog::Service

      requires    :hp_secret_key, :hp_account_id, :hp_tenant_id
      recognizes  :hp_auth_uri, :hp_servicenet, :hp_cdn_ssl, :hp_cdn_uri, :persistent, :connection_options, :hp_use_upass_auth_style, :hp_auth_version

      secrets     :hp_secret_key

      model_path 'fog/hp/models/storage'
      model       :directory
      collection  :directories
      model       :file
      collection  :files

      request_path 'fog/hp/requests/storage'
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
          unless @hp_cdn_uri.nil?
            @cdn ||= Fog::CDN.new(
              :provider       => 'HP',
              :hp_account_id  => @hp_account_id,
              :hp_secret_key  => @hp_secret_key,
              :hp_auth_uri    => @hp_auth_uri,
              :hp_cdn_uri     => @hp_cdn_uri,
              :hp_tenant_id   => @hp_tenant_id,
              :connection_options => @connection_options
            )
            if @cdn.enabled?
              @cdn
            end
          else
            nil
          end
        end

        def url
          "#{@scheme}://#{@host}:#{@port}#{@path}"
        end

        def acl_to_header(acl)
          header = {}
          case acl
            when "private"
              header['X-Container-Read']  = ""
              header['X-Container-Write'] = ""
            when "public-read"
              header['X-Container-Read']  = ".r:*,.rlistings"
            when "public-write"
              header['X-Container-Write'] = "*"
            when "public-read-write"
              header['X-Container-Read']  = ".r:*,.rlistings"
              header['X-Container-Write'] = "*"
          end
          header
        end

        def header_to_acl(read_header=nil, write_header=nil)
          acl = nil
          if read_header.nil? && write_header.nil?
            acl = nil
          elsif !read_header.nil? && read_header.include?(".r:*") && write_header.nil?
            acl = "public-read"
          elsif !write_header.nil? && write_header.include?("*") && read_header.nil?
            acl = "public-write"
          elsif !read_header.nil? && read_header.include?(".r:*") && !write_header.nil? && write_header.include?("*")
            acl = "public-read-write"
          end
        end
      end

      class Mock
        include Utils
        def self.acls(type)
          type
        end

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :acls => {
                :container => {},
                :object => {}
              },
              :containers => {}
            }
            end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          require 'mime/types'
          @hp_secret_key = options[:hp_secret_key]
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
        include Utils
        attr_reader :hp_cdn_ssl

        def initialize(options={})
          require 'mime/types'
          @hp_secret_key = options[:hp_secret_key]
          @hp_account_id = options[:hp_account_id]
          @hp_auth_uri   = options[:hp_auth_uri]
          @hp_cdn_ssl    = options[:hp_cdn_ssl]
          @connection_options = options[:connection_options] || {}
          ### Set an option to use the style of authentication desired; :v1 or :v2 (default)
          auth_version = options[:hp_auth_version] || :v2
          ### Pass the service type for object storage to the authentication call
          options[:hp_service_type] = "object-store"
          @hp_tenant_id = options[:hp_tenant_id]

          ### Make the authentication call
          if (auth_version == :v2)
            # Call the control services authentication
            credentials = Fog::HP.authenticate_v2(options, @connection_options)
            # the CS service catalog returns the cdn endpoint
            @hp_storage_uri = credentials[:endpoint_url]
            @hp_cdn_uri  = credentials[:cdn_endpoint_url]
          else
            # Call the legacy v1.0/v1.1 authentication
            credentials = Fog::HP.authenticate_v1(options, @connection_options)
            # the user sends in the cdn endpoint
            @hp_storage_uri = options[:hp_auth_uri]
            @hp_cdn_uri  = options[:hp_cdn_uri]
          end

          @auth_token = credentials[:auth_token]

          uri = URI.parse(@hp_storage_uri)
          @host   = options[:hp_servicenet] == true ? "snet-#{uri.host}" : uri.host
          @path   = uri.path
          @persistent = options[:persistent] || false
          @port   = uri.port
          @scheme = uri.scheme
          Excon.ssl_verify_peer = false if options[:hp_servicenet] == true

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
              Fog::Storage::HP::NotFound.slurp(error)
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
